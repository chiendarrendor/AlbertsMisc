use List::Util;

package Player;

sub new 
{
    my ($class,$name,$execcmd) = @_;
    my $this = {};
    bless $this,$class;
    $this->{NAME} = $name;
    $this->{TILES} = [];
    $this->{EXECCMD} = $execcmd;
    return $this;
}

package Tile;
# name is one of 
# start
# end
# negator
# minus_X
# plus_X

#contents is array of
# <playername>_<tokenid>
# or
# guardian_<tokenid>

my $uid = 0;

sub new
{
    my ($class,$name,$startingpiece) = @_;
    my $this = {};
    bless $this,$class;
    $this->{NAME} = $name;
    $this->{UID} = $uid++;
    $this->{CONTENTS} = [];

    if (defined $startingpiece)
    {
	$this->AddPiece($startingpiece);
    }

    return $this;
}

sub AddPiece
{
    my ($this,$piece) = @_;
    push @{$this->{CONTENTS}},$piece;
}

package State;

# items to store:
# players, with their taken tiles
# the most recent die roll for each player
# the most recent move for each player
# the board, with tile info, with player tokens and guardians.


# makes a new empty board
sub new
{
    my ($class) = @_;
    my $this = {};
    bless $this,$class;

    $this->{PLAYERS} = [];
    $this->{BOARD} = [];
    $this->{CURPLAYERINDEX} = 0;

    push @{$this->{BOARD}},new Tile("start");
    my $i;
    for ($i = 1 ; $i <= 8 ; ++$i)
    {
	push @{$this->{BOARD}},new Tile("minus_" . $i);
    }
    for ($i = 0 ; $i < 6 ; ++$i)
    {
	my $nt = new Tile("negator","guardian_".$i);
	push @{$this->{BOARD}},$nt;
    }
    for ($i = 8 ; $i >= 1 ; --$i)
    {
	my $nt = new Tile("plus_" . $i);
	push @{$this->{BOARD}},$nt;
	if ($i >= 7)
	{
	    $nt->AddPiece("guardian_" . ($i-1));
	}
    }
    for ($i = 1 ; $i <= 10 ; ++$i)
    {
	my $nt = new Tile("minus_" . $i);
	push @{$this->{BOARD}},new Tile("minus_" . $i);
    }	    
    push @{$this->{BOARD}},new Tile("end");

    return $this;
}

sub CurPlayerDone()
{
    my ($this) = @_;
    my $curplayername = $this->{PLAYERS}->[$this->{CURPLAYERINDEX}]->{NAME};

    for (my $i = 0 ; $i < @{$this->{BOARD}} ; ++$i)
    {
	for (my $j = 0 ; $j < @{$this->{BOARD}->[$i]->{CONTENTS}} ; ++$j)
	{
	    if ($this->{BOARD}->[$i]->{NAME} ne "end" &&
		$this->{BOARD}->[$i]->{CONTENTS}->[$j] =~ /$curplayername/)
	    {
		return 0;
	    }
	}
    }
    return 1;
}

sub NextPlayer
{
    my ($this) = @_;
    ++$this->{CURPLAYERINDEX};
    if ($this->{CURPLAYERINDEX} >= scalar @{$this->{PLAYERS}})
    {
	$this->{CURPLAYERINDEX} = 0;
    }
}






sub AddNewPlayer
{
    my ($this,$playername,$execcmd) = @_;
    my $newplayer = new Player($playername,$execcmd);
    push @{$this->{PLAYERS}},$newplayer;
    for (my $i = 0 ; $i < 3 ; ++$i)
    {
	$this->{BOARD}->[0]->AddPiece($playername . "_" . $i);
    }
}

sub ShufflePlayers
{
    my ($this) = @_;
    my @tary =List::Util::shuffle(@{$this->{PLAYERS}});
    $this->{PLAYERS} = \@tary;
}

sub GetStateXML
{
    my ($this) = @_;
    my $result = "";

    $result .= "<?xml version=\"1.0\" encoding=\"us-ascii\"?>\n";
    $result .= "<thatslife turn=\"" . $this->{CURTURN} . "\">\n";
    $result .= "  <players>\n";
    for (my $i = 0 ; $i < scalar @{$this->{PLAYERS}} ; ++$i)
    {
	$result .= "    <player name=\"" . $this->{PLAYERS}->[$i]->{NAME} . "\" ";
	if ($this->{CURPLAYERINDEX} == $i)
	{
	    $result .= "currentroll=\"" . $this->{PLAYERS}->[$i]->{ROLL} . "\">\n";
	}
	else
	{
	    $result .= "lastroll=\"" . $this->{PLAYERS}->[$i]->{ROLL} . "\">\n";
	}
	for (my $j = 0 ; $j < scalar @{$this->{PLAYERS}->[$i]->{TILES}} ; ++$j)
	{
	    $result .= "      <claimedtile name=\"".$this->{PLAYERS}->[$i]->{TILES}->[$j]->{NAME}."\"/>\n";
	}
	$result.= "    </player>\n";
    }
    $result .= "  </players>\n";
    $result .= "  <board>\n";
    for (my $i = 0 ; $i < scalar @{$this->{BOARD}} ; ++$i)
    {
	$result .= "    <tile name=\"".$this->{BOARD}->[$i]->{NAME}."\">\n";
	for (my $j = 0 ; $j < scalar @{$this->{BOARD}->[$i]->{CONTENTS}} ; ++$j)
	{
	    my $item = $this->{BOARD}->[$i]->{CONTENTS}->[$j];
	    if ($item =~ /^guardian_(\d)$/)
	    {
		$result .= "      <guardian id=\"" . $1 . "\"/>\n";
	    }
	    elsif($item =~ /^(\w+)_(\d)$/)
	    {
		$result .= "      <token owner=\"" . $1 . "\" id=\"" . $2 . "\"/>\n";
	    }
	}
	$result .= "    </tile>\n";
    }
    $result .= "  </board>\n";
    $result .= "</thatslife>\n";
    return $result;
}
	
# to validate:
# a) distance is between 1 and 6
# b) curplayer is an extant player
# c) piecetype is either 'token' or 'guardian'
# d) curplayer/piecetype/pieceid is 
#    1) extant
#    2) not on end
#    3) if a guardian, sharing a space with a non-guardian
# return a non-empty error message string if there are any issues.
# to execute:
#   remember piece's current location ('prior')
#   move piece distance spaces forward (or to end, whichever comes first)
#   if prior location is now empty, remove tile from board and award it to current player
sub ValidateAndExecuteMove
{
    my ($this,$curplayer,$piecetype,$pieceid,$distance) = @_;
    my $piecename;
 
    return "Illegal dieroll $distance" unless ($distance >= 1 && $distance <= 6);

    my $pindex = -1;
    for (my $i = 0 ; $i < scalar @{$this->{PLAYERS}} ; ++$i)
    {
	if ($this->{PLAYERS}->[$i]->{NAME} eq $curplayer)
	{
	    $pindex = $i;
	    last;
	}
    }

    return "Unknown current player $curplayer" if $pindex == -1;
    
    if ($piecetype eq 'token')
    {
	$piecename = "${curplayer}_$pieceid" ;
    } 
    elsif ($piecetype eq 'guardian')
    {
	$piecename = "guardian_$pieceid";
    }
    else
    {
	return "Illegal piece type $piecetype";
    }

    my $origspace = -1;
    my $origloc = -1;
    my $pcount;
    for (my $i = 0 ; $i < scalar @{$this->{BOARD}} ; ++$i)
    {
	$pcount = 0;
	for (my $j = 0 ; $j < scalar @{$this->{BOARD}->[$i]->{CONTENTS}} ; ++$j)
	{
	    ++$pcount if ($this->{BOARD}->[$i]->{CONTENTS}->[$j] !~ /guardian/);

	    if ($this->{BOARD}->[$i]->{CONTENTS}->[$j] eq $piecename)
	    {
		$origspace = $i;
		$origloc = $j;
	    }
	}
	last unless $origspace == -1;
    }

    return "No such Piece as $piecename" if $origspace == -1;
    return "Piece $piecename on end" if $this->{BOARD}->[$origspace]->{NAME} eq "end";
    return "$piecename not with tokens" if $piecetype eq 'guardian' && $pcount == 0;

    # ok..if we get here, then we can do what we need to do.
    splice(@{$this->{BOARD}->[$origspace]->{CONTENTS}},$origloc,1);

    my $newspace = $origspace;
    while($distance > 0 && $this->{BOARD}->[$newspace]->{NAME} ne 'end')
    {
	++$newspace;
	--$distance;
    }

    push @{$this->{BOARD}->[$newspace]->{CONTENTS}},$piecename;

    if (scalar @{$this->{BOARD}->[$origspace]->{CONTENTS}} == 0 &&
	$this->{BOARD}->[$origspace]->{NAME} ne 'start')
    {
	push @{$this->{PLAYERS}->[$pindex]->{TILES}},$this->{BOARD}->[$origspace];
	splice(@{$this->{BOARD}},$origspace,1);
    }

    return "";
}

package Competitor;

sub new
{
    my ($class,$name,$execcmd) = @_;
    my $this = {};
    bless $this,$class;

    $this->{NAME} = $name;
    $this->{EXECCMD} = $execcmd;
    return $this;
}


package OneGame;

sub DieRoll
{
    return 1 + int(rand(6));
}


sub Run
{
    my ($comparray,$workdir,$outfile) = @_;

    # make board
    my $board = new State();
    # add players
    for (my $i = 0 ; $i < @$comparray ; ++$i)
    {
	$board->AddNewPlayer($comparray->[$i]->{NAME},$comparray->[$i]->{EXECCMD});
    }
    # randomly order players
    $board->ShufflePlayers();

    my $numplayers = scalar @$comparray;
    my $numskips = 0; # the number of players consecutively skipped

    open(OFD,">$outfile");
    for (my $i = 0 ; $i < @{$board->{PLAYERS}} ; ++$i)
    {
	print OFD "," if ($i != 0);
	print OFD $board->{PLAYERS}->[$i]->{NAME};
    }
    print OFD "\n";

    for (my $i = 0 ; $i < @{$board->{BOARD}} ; ++$i)
    {
	print OFD "," if ($i != 0);
	print OFD $board->{BOARD}->[$i]->{NAME};
	for (my $j = 0 ; $j < @{$board->{BOARD}->[$i]->{CONTENTS}} ; ++$j)
	{
	    if ($board->{BOARD}->[$i]->{CONTENTS}->[$j] =~ /guardian/)
	    {
		print OFD "(",$board->{BOARD}->[$i]->{CONTENTS}->[$j],")";
	    }
	}
    }
    print OFD "\n";





    # game is ready to start.  CURPLAYERINDEX starts at 0 which is fine.
    while(1)
    {
	if ($board->CurPlayerDone())
	{
	    ++$numskips;
	    last if $numskips == $numplayers;
	    $board->NextPlayer();
	    next;
	}
	$numskips = 0;
    
	my $curplayer = $board->{PLAYERS}->[$board->{CURPLAYERINDEX}];
    
	# roll die
	$curplayer->{ROLL} = DieRoll();
	
	# generate board file
	open(XMLFD,">$workdir/board.xml") || die("Can't write board.xml");
	print XMLFD $board->GetStateXML();
	close(XMLFD);

        #   get player move
	my $move = `$curplayer->{EXECCMD} $curplayer->{NAME} $workdir/board.xml $workdir/$curplayer->{NAME}`;

	chomp $move;
	my @movar = split(" ",$move);

	if ($movar[0] eq "error")
	{
	    return "player $curplayer->{NAME} $move";
	}
	
	if (scalar @movar != 2)
	{
	    return "adjucator $curplayer->{NAME} Played Illegally";
	}

	my $result = $board->ValidateAndExecuteMove($curplayer->{NAME},
						    $movar[0],
						    $movar[1],
						    $curplayer->{ROLL});


	print OFD "$curplayer->{NAME},$curplayer->{ROLL},$movar[0],$movar[1]\n";

	if (length($result) > 0)
	{
	    return "adjucator $curplayer->{NAME} $result";
	}

        #   next player is current player
	$board->NextPlayer();
    }
    close(OFD);
}	
    
# still to write
# CurPlayerDone boolean, true if current player has all their pieces on 'end'
# NextPlayer void, increments current player counter    



# sequence of events:
#
# make board
# add players (adds tokens to start)
# randomly order players
# start game
# current player is first player
# forever
#   if all player's tokens are on end, skip to next player
#   if all players are skipped, end game
#   roll die
#   generate board file
#   get player move
#--- all done in ValidateAndExecuteMove
#   validate player move
#     if move is a token, ensure it is not on end
#     if move is a guardian, ensure that it shares the space with a player's token
#   if move is a token, remember starting location
#   execute move (token/guardian is now 'roll' spaces ahead, or on end if it reaches that space first)
#   if move is a token, see if starting location is empty (no tokens or guardians)
#   if so, remove tile from board and award it to player
# ---
#   next player is current player


package main;

sub TestValidateAndExecuteMove
{
    $b = new State();
    $b->AddNewPlayer("GoldenDogs","perl gd.pl");
    $b->AddNewPlayer("Pagans","perl pag.pl");
    $b->AddNewPlayer("GamerGeeks","perl gg.pl");
    $b->AddNewPlayer("Advertisers","perl adv.pl");

    $orig = $b->GetStateXML();
    print $orig;

    print "Illegal DieRoll?: ",$b->ValidateAndExecuteMove("Pagans",'guardian',2,7),"\n";
    print "Illegal DieRoll?: ",$b->ValidateAndExecuteMove("Pagans",'guardian',2,0),"\n";
    print "Unknown Player?: ",$b->ValidateAndExecuteMove("StraightEdges",'guardian',2,3),"\n";
    print "Unknown piece type?: ",$b->ValidateAndExecuteMove("Pagans",'foo',2,3),"\n";
    print "No Such Piece?: ",$b->ValidateAndExecuteMove("Pagans",'token',3,3),"\n";
    print "No Such Piece?: ",$b->ValidateAndExecuteMove("Pagans",'guardian',8,3),"\n";
    print "Immobile Guardian?: ",$b->ValidateAndExecuteMove("Pagans",'guardian',6,3),"\n";
    print "Identical?: ",($b->GetStateXML() eq $orig),"\n";

    print "Moved?: ",$b->ValidateAndExecuteMove("Pagans",'token',0,4),"\n";
    print $b->GetStateXML();
    print "Moved?: ",$b->ValidateAndExecuteMove("Advertisers",'token',0,6),"\n";
    print $b->GetStateXML();
    print "Moved?: ",$b->ValidateAndExecuteMove("Pagans",'token',0,5),"\n";
    print $b->GetStateXML();
    print "Moved?: ",$b->ValidateAndExecuteMove("Pagans",'guardian',0,1),"\n";
    print $b->GetStateXML();

    #  guardian with other guardians
    print "Immobile Guardian?: ",$b->ValidateAndExecuteMove("Pagans",'guardian',0,1),"\n";

    #  piece on end
    print "Moved?: ",$b->ValidateAndExecuteMove("Pagans",'token',0,6),"\n";
    print "Moved?: ",$b->ValidateAndExecuteMove("Pagans",'token',0,6),"\n";
    print "Moved?: ",$b->ValidateAndExecuteMove("Pagans",'token',0,6),"\n";
    print "Moved?: ",$b->ValidateAndExecuteMove("Pagans",'token',0,3),"\n";
    print "Moved?: ",$b->ValidateAndExecuteMove("Pagans",'token',0,6),"\n";
    print $b->GetStateXML();
    print "On End?: ",$b->ValidateAndExecuteMove("Pagans",'token',0,6),"\n";
}

@competitors=
(
 new Competitor("GoldenDogs","perl gd.pl"),
 new Competitor("Pagans","perl pag.pl"),
 new Competitor("GamerGeeks","perl gg.pl"),
 new Competitor("Advertisers","perl adv.pl"),
 new Competitor("Naughties","perl nau.pl"),
 new Competitor("Muggles","perl mug.pl")
 );



print "Status: ",OneGame::Run(\@competitors,".","foo.txt"),"\n";
