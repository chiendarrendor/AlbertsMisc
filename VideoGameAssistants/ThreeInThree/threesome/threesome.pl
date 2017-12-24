# structure:
# {
#   ROOMS = { } (roomname)
#           {
#              COLORS = [ ] ( + 3 X's)
#              NUMTARGETS
#              DOORS [ ]
#              {
#                    DESTROOM (room name)
#                    COLOR1
#                    COLOR2
#              }
#   INITIALROOMS = [ ] (roomnames)
#
# above is board (doesn't change)
# below is state (does)
#   PEOPLE = [ ]
#           {
#              ROOM
#              COLORINDEX
#           }
#   WINGRADE
#   BOARD
#   MOVE
#   PARENT


BEGIN { push(@INC,"../Common/Perl"); }
use Astar;
use ShowDataStructure;
use boardBFS;

package Board;
sub new
{
    my ($class) = @_;
    my $this = {};
    bless ($this,$class);

    $this->{ROOMS} = {};
    $this->{INITIALROOMS} = [];


    return $this;
}

sub AddRoom
{
    my ($this,$roomname) = @_;

    return 0 if (exists $this->{ROOMS}->{$roomname});
    $this->{ROOMS}->{$roomname} = {};
    $this->{ROOMS}->{$roomname}->{COLORS} = [ 'X','X','X' ];
    $this->{ROOMS}->{$roomname}->{NUMTARGETS} = 0;
    $this->{ROOMS}->{$roomname}->{DOORS} = [];

    return 1;
}

sub AddColorToRoom
{
    my ($this,$roomname,$color) = @_;

    return 0 if (!exists $this->{ROOMS}->{$roomname});
    push(@{$this->{ROOMS}->{$roomname}->{COLORS}},$color);
    
    return 1;
}

sub AddColorsToRoom
{
    my ($this,$roomname,@color) = @_;
    
    my $i;

    for ($i = 0 ; $i < @color ; $i++)
    {
	return 0 if (!$this->AddColorToRoom($roomname,$color[$i]));
    }
    return 1;
}

sub AddTargetToRoom
{
    my ($this,$roomname) = @_;
    return 0 if (!exists $this->{ROOMS}->{$roomname});
    $this->{ROOMS}->{$roomname}->{NUMTARGETS}++;

    return 1;
}

sub AddDoor
{
    my ($this,$room1,$room2,$color1,$color2) = @_;

    return 0 if (!exists $this->{ROOMS}->{$room1});
    return 0 if (!exists $this->{ROOMS}->{$room2});

    my $rref1 = $this->{ROOMS}->{$room1};
    my $rref2 = $this->{ROOMS}->{$room2};

    my $d1 = {};
    $d1->{DESTROOM} = $room2;
    $d1->{COLOR1} = $color1;
    $d1->{COLOR2} = $color2;
    push(@{$rref1->{DOORS}},$d1);

    my $d2 = {};
    $d2->{DESTROOM} = $room1;
    $d2->{COLOR1} = $color1;
    $d2->{COLOR2} = $color2;
    push(@{$rref2->{DOORS}},$d2);

    return 1;
}

sub AddPlayer
{
    my ($this,$roomname) = @_;

    return 0 if (!exists $this->{ROOMS}->{$roomname});

    push(@{$this->{INITIALROOMS}},$roomname);

    return 1;
}


package MaxDepthFunctor;
sub new
{
    my ($class) = @_;
    my $this = {};
    $this->{DEPTH} = 0;
    bless ($this,$class);
    return $this;
}

sub RoomVisited
{
    my ($this,$thisroom,$sourceroom,$depth) = @_;

    if ($depth > $this->{DEPTH})
    {
	$this->{DEPTH} = $depth;
    }

    return 1;
}

sub GetMaxDepth
{
    my ($this) = @_;
    return $this->{DEPTH};
}

package PlayerValidationFunctor;
sub new
{
    my ($class,$initrooms,$numtargets) = @_;
    my $this = {};
    $this->{INITROOMS} = $initrooms;
    $this->{NUMTARGETS} = $numtargets;
    $this->{DEPTH} = 0;
    bless ($this,$class);
    return $this;
}

sub RoomVisited
{
    my ($this,$thisroom,$sourceroom,$depth) = @_;

    while($this->{INITROOMS}->{$thisroom} > 0 && $this->{NUMTARGETS} > 0)
    {
	$this->{INITROOMS}->{$thisroom}--;
	$this->{NUMTARGETS}--;
	$this->{DEPTH} += $depth;
    }

    if ($this->{NUMTARGETS} == 0)
    {
	return undef;
    }
    
    return 1;
}

sub GetTargetDepth
{
    my ($this) = @_;
    return $this->{DEPTH};
}

package State;

sub new
{
    my ($class,$board) = @_;

    # 1. validate that the board got three starting player locations
    # 1a. make a hash of the starting player locations by room

    my $rct = 0;
    my %initrooms;
    foreach my $sproom (@{$board->{INITIALROOMS}})
    {
	$rct++;
	$initrooms{$sproom}++;
    }

    if ($rct != 3)
    {
	print "Board does not have 3 starting player locations\n";
	return undef;
    }
	


    # 2. validate that the board got three terminating player locations
    my $numtargets = 0;
    foreach $key (keys(%{$board->{ROOMS}}))
    {
	$numtargets += $board->{ROOMS}->{$key}->{NUMTARGETS};
    }
    if ($numtargets != 3)
    {
	print "Board does not have 3 target locations.\n";
	return undef;
    }
    
    # validate that all targets can be achieved by all players
    # for each room with at least one target
    #     numtargetsused = 0
    #     do a BFS starting from that room
    #          for each room visited with one or more unmarked players
    #              mark players and increment numtargetsused until
    #                   a. numtargetsused = startingroom.numtargets (success for that room,stop)
    #                   b. all players in the room are marked. (keep going)
    #    if (numtargetsused != startingroom) fail
    
    my $maxdist = 0;

    foreach $key (keys(%{$board->{ROOMS}}))
    {
	my $room = $board->{ROOMS}->{$key};
	next if $room->{NUMTARGETS} == 0;

	my $plfunctor = new PlayerValidationFunctor(\%initrooms,$room->{NUMTARGETS});

	my $result = boardBFS::doBFS($board,$plfunctor,$key);

	if ($result != 2)
	{
	    print "Targets in room $key not accessable\n";
	    return undef;
	}

	# if we get here, see what the greatest depth of this set of targets is
	my $distfunc = new MaxDepthFunctor();
	boardBFS::doBFS($board,$distfunc,$key);
	$maxdist += $distfunc->GetMaxDepth() * $room->{NUMTARGETS};
    }

    my $this = {};
    $this->{WINGRADE} = $maxdist;
    $this->{BOARD} = $board;

    my $stateroom;
    my $initialcell = 0;
    
    foreach $stateroom (@{$board->{INITIALROOMS}})
    {
	$this->{PEOPLE}->[$initialcell] = { ROOM => $stateroom, COLORINDEX => $initialcell };
	$initialcell++;
    }

    bless ($this,$class);
    return $this;
}

sub CanonicalKey
{
    my ($this) = @_;
    my $i;

    my %result;

    for ($i = 0 ; $i < 3 ; $i++)
    {
	my $person = $this->{PEOPLE}->[$i];
	$result{$person->{ROOM}}->{$person->{COLORINDEX}} = 1;
    }

    my $roomkey;
    my $colorkey;
    my $result;
    
    foreach $roomkey (sort keys %result)
    {
	$result .= "/" . $roomkey;
	foreach $colorkey (sort keys %{$result{$roomkey}})
	{
	    $result .= "-" . $colorkey;
	}
    }
    return $result;
}


sub GetColorOfPlayer
{
    my ($this,$playerindex) = @_;

    my $person = $this->{PEOPLE}->[$playerindex];
    my $roomname = $person->{ROOM};
    my $colorindex = $person->{COLORINDEX};
    my $room = $this->{BOARD}->{ROOMS}->{$roomname};
    my $colorname = $room->{COLORS}->[$colorindex];

    return $colorname;
}



sub DisplayString
{
    my ($this) = @_;
    my $i;
    my $result;

    for ($i = 0 ; $i < 3 ; $i++)
    {
	my $person = $this->{PEOPLE}->[$i];
	my $roomname = $person->{ROOM};

	$result .= "$i: $roomname->" . $this->GetColorOfPlayer($i) . "  ";
    }
    return $result;
}

sub Move
{
    my ($this) = @_;
    return $this->{MOVE};
}

sub Parent
{
    my ($this) = @_;
    return $this->{PARENT};
}

sub WinGrade
{
    my ($this) = @_;
    return $this->{WINGRADE};
}

sub Grade
{
    my ($this) = @_;
    my $distance = 0;

    my $board = $this->{BOARD};
    my $key;

    my $i;
    my %initrooms;

    for ($i = 0 ; $i < @{$this->{PEOPLE}} ; $i++)
    {
	my $person = $this->{PEOPLE}->[$i];
	$initrooms{$person->{ROOM}}++;
    }

    foreach $key (keys(%{$board->{ROOMS}}))
    {
	my $room = $board->{ROOMS}->{$key};
	next if $room->{NUMTARGETS} == 0;

	my $plfunctor = new PlayerValidationFunctor(\%initrooms,$room->{NUMTARGETS});

	boardBFS::doBFS($board,$plfunctor,$key);

	$distance += $plfunctor->GetTargetDepth();
    }

    return $this->{WINGRADE} - $distance;
}

sub Clone
{
    my ($this) = @_;

    my $newstate = {};
    bless ($newstate,ref $this);

    $newstate->{WINGRADE} = $this->{WINGRADE};
    $newstate->{BOARD} = $this->{BOARD};
    $newstate->{PARENT} = $this->CanonicalKey();

    my $i;

    for ($i = 0 ; $i < 3 ; $i++)
    {
	$newstate->{PEOPLE}->[$i]->{ROOM} = $this->{PEOPLE}->[$i]->{ROOM};
	$newstate->{PEOPLE}->[$i]->{COLORINDEX} = $this->{PEOPLE}->[$i]->{COLORINDEX};
    }

    return $newstate;
}

sub Successors
{
    my ($this) = @_;

    my @result;

    my $playerindex;
    
    my %locationhash;

    for ($i = 0 ; $i < 3 ; $i++)
    {
	my $person = $this->{PEOPLE}->[$i];
	$locationhash{$person->{ROOM}}->{$person->{COLORINDEX}} = 1;
    }

    # first, color changes in player rooms:
    for ($playerindex = 0 ; $playerindex < 3 ; $playerindex++)
    {
	my $player = $this->{PEOPLE}->[$playerindex];
	my $roomname = $player->{ROOM};
	my $room = $this->{BOARD}->{ROOMS}->{$roomname};

	my $colorindex;
	
	for ($colorindex = 3 ; $colorindex < @{$room->{COLORS}} ; $colorindex++)
	{
	    next if (exists $locationhash{$roomname}->{$colorindex});

	    my $newstate = $this->Clone();

	    $newstate->{PEOPLE}->[$playerindex]->{COLORINDEX} = $colorindex;
	    $newstate->{MOVE} = "room $roomname, " . 
		$this->GetColorOfPlayer($playerindex) . "->" . $newstate->GetColorOfPlayer($playerindex);
	    push @result,$newstate;
	}
    }

    # second, room changes
    for ($playerindex = 0 ; $playerindex < 3 ; $playerindex++)
    {
	my $player = $this->{PEOPLE}->[$playerindex];
	my $roomname = $player->{ROOM};
	my $room = $this->{BOARD}->{ROOMS}->{$roomname};

	my %colors;
	undef %colors;

	my $opi;

	for ($opi = 0 ; $opi < 3 ; $opi++)
	{
	    next if $opi == $playerindex;
	    $colors{$this->GetColorOfPlayer($opi)}++;
	}

	my $door;

	foreach $door (@{$room->{DOORS}})
	{
	    if ($door->{COLOR1} eq $door->{COLOR2})
	    {
		next if ($colors{$door->{COLOR1}} < 2);
	    }
	    else
	    {
		next if ($colors{$door->{COLOR1}} < 1);
		next if ($colors{$door->{COLOR2}} < 1);
	    }

	    my $newstate = $this->Clone();

	    $newstate->{PEOPLE}->[$playerindex]->{ROOM} = $door->{DESTROOM};
	    $newstate->{PEOPLE}->[$playerindex]->{COLORINDEX} = $playerindex;
	    $newstate->{MOVE} = $this->GetColorOfPlayer($playerindex) . " $roomname to " . $door->{DESTROOM};
	    push @result,$newstate;
	}
    }

    return @result;
}

package main;

my $board = new Board();

# AddRoom(name) AddColorToRoom(name,color) AddColorsToRoom(name,@color) AddTargetToRoom(room)
# AddDoor(room,target,color1,color2) AddPlayer(room)

die("Bad Command line\n") if (@ARGV != 1);
open(EVALBLOCK,"$ARGV[0]") || die("Can't open $ARGV[0]\n");
my $evalstring = join("",<EVALBLOCK>);

eval $evalstring;

my $state = new State($board);

exit(1) if !$state;

Astar::Astar($state,1);
