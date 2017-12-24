use ShowDataStructure;

my $path="KNPNPQKQPNKNKQPQ";
my @pieces =
    ( { NAME=>"KS", DIRS=>"LR" },
      { NAME=>"KC", DIRS=>"LD" },
      { NAME=>"KP", DIRS=>"UL" },
      { NAME=>"KW", DIRS=>"RD" },
      { NAME=>"QW", DIRS=>"LR" },
      { NAME=>"QP", DIRS=>"UR" },
      { NAME=>"QS", DIRS=>"LD" },
      { NAME=>"QC", DIRS=>"LR" },
      { NAME=>"NS", DIRS=>"LU" },
      { NAME=>"NW", DIRS=>"LD" },
      { NAME=>"NC", DIRS=>"UR" },
      { NAME=>"NP", DIRS=>"RD" },
      { NAME=>"PW", DIRS=>"UL" },
      { NAME=>"PP", DIRS=>"RD" },
      { NAME=>"PC", DIRS=>"LR" },
      { NAME=>"PS", DIRS=>"RU" }
      );

my @queue;



package Map;

my $dflag = 0;

sub dprint
{
    print @_ if $dflag;;
}


sub new
{
    my ($class) = @_;
    my $this = {};
    bless $this,$class;

    $this->{PATHINDEX} = 0;
    $this->{OPX} = 0;
    $this->{OPY} = 0;
    # direction of path leading into the OP cell (i.e. the dir that lead out of the prev cell
    $this->{FROMDIR} = ""; 

    #contains a hash of {X,Y,PATHINDEX} keyed by the name of the tile
    $this->{USEDNAMES} = {};
    #contains a hash keyed by {X,Y} of hash of {NAME,DIRS,PATHINDEX}
    $this->{USEDSPACES} = {};
    #contains an array of hash of {X,Y,NAME,DIRS}
    $this->{TILEPATH} = [];
    
    return $this;
}

sub Clone
{ 
    my ($this) = @_;
    my $result = new Map();
    $result->{PATHINDEX} = $this->{PATHINDEX};
    $result->{OPX} = $this->{OPX};
    $result->{OPY} = $this->{OPY};
    $result->{FROMDIR} = $this->{FROMDIR};

    my %unames = %{$this->{USEDNAMES}};
    $result->{USEDNAMES} = \%unames;

    my %uspaces = %{$this->{USEDSPACES}};
    $result->{USEDSPACES} = \%uspaces;

    my @tpath = @{$this->{TILEPATH}};
    $result->{TILEPATH} = \@tpath;

    return $result;
}


# add the given piece to the current location, set FROMDIR to the new dir
# and use the new dir to update OPX and OPY
sub Add
{
    my ($this,$piece,$newdir) = @_;
    my $unameent = 
    {
	X=>$this->{OPX},
	Y=>$this->{OPY},
	PATHINDEX=>$this->{PATHINDEX}
    };

    my $sspaceent = 
    {
	NAME=>$piece->{NAME},
	DIRS=>$piece->{DIRS},
	PATHINDEX=>$this->{PATHINDEX}
    };
    my $tpent =
    {
	X=>$this->{OPX},
	Y=>$this->{OPY},
	NAME=>$piece->{NAME},
	DIRS=>$piece->{DIRS}
    };
    $this->{USEDNAMES}->{$piece->{NAME}} = $unameent;
    $this->{USEDSPACES}->{$this->{OPX},$this->{OPY}} = $sspaceent;
    push @{$this->{TILEPATH}},$tpent;

    $this->{FROMDIR} = $newdir;
    my $newloc = $this->LocOfDirPlusCurrent($newdir);
    $this->{OPX} = $newloc->{X};
    $this->{OPY} = $newloc->{Y};
    $this->{PATHINDEX}++;
}

    




sub Opp
{
    my ($x) = @_;
    return "U" if $x eq "D";
    return "D" if $x eq "U";
    return "L" if $x eq "R";
    return "R" if $x eq "L";
    die("bad char to Opp: $x");
}

sub Extent
{
    my ($this) = @_;
    my $result =
    {
	MINX=>100,
	MAXX=>-100,
	MINY=>100,
	MAXY=>-100
	};
    for (my $i = 0 ; $i < @{$this->{TILEPATH}} ; ++$i)
    {
	$result->{MINX} = $this->{TILEPATH}->[$i]->{X} if $this->{TILEPATH}->[$i]->{X} < $result->{MINX};
	$result->{MAXX} = $this->{TILEPATH}->[$i]->{X} if $this->{TILEPATH}->[$i]->{X} > $result->{MAXX};
	$result->{MINY} = $this->{TILEPATH}->[$i]->{Y} if $this->{TILEPATH}->[$i]->{Y} < $result->{MINY};
	$result->{MAXY} = $this->{TILEPATH}->[$i]->{Y} if $this->{TILEPATH}->[$i]->{Y} > $result->{MAXY};
    }
    return $result;
}

sub ExtentPlusTile
{
    my ($this,$x,$y) = @_;
    my $result = $this->Extent();
    
    $result->{MINX} = $x if $x < $result->{MINX};
    $result->{MAXX} = $x if $x > $result->{MAXX};
    $result->{MINY} = $y if $y < $result->{MINY};
    $result->{MAXY} = $y if $y > $result->{MAXY};
    return $result;
}

sub LocOfDirPlusCurrent
{
    my ($this,$dir) = @_;
    my $result = 
    {
	X=>$this->{OPX},
	Y=>$this->{OPY}
    };

    if ($dir eq 'U') { $result->{Y}--; }
    if ($dir eq 'D') { $result->{Y}++; }
    if ($dir eq 'L') { $result->{X}--; }
    if ($dir eq 'R') { $result->{X}++; }
    return $result;
}

sub Operate
{
    my ($this) = @_;

    # if PATHINDEX = length($path) return
    if ($this->{PATHINDEX} == length($path)) 
    {
	return;
    }

    #determine desired piece type
    my $ptype = substr($path,$this->{PATHINDEX},1);

    #determine what pieces can go into the OP cell:
    for (my $i = 0 ; $i < @pieces ; ++$i)
    {
	my $piece = $pieces[$i];
	dprint("piece ",$piece->{NAME},"(",$piece->{DIRS},")...");
	# 1. piece NAME must start with the same letter as the PATHINDEX character of $path
	if (substr($piece->{NAME},0,1) ne $ptype)
	{
	    dprint("rejected bad name\n");
	    next;
	}

	# if this isn't the first one...
	my $odir;
	if ($this->{PATHINDEX} > 0)
	{
	    dprint("not first...");
	    # 2. piece DIRS must contain the opposite of FROMDIR
	    if (index($piece->{DIRS},Opp($this->{FROMDIR})) == -1)
	    {
		dprint("rejected no incoming path\n");
		next;
	    }
	    $odir = substr($piece->{DIRS},0,1) eq Opp($this->{FROMDIR}) ?
		substr($piece->{DIRS},1,1) : substr($piece->{DIRS},0,1);

	    # 3. piece must not already be on map
	    if (exists($this->{USEDNAMES}->{$piece->{NAME}}))
	    {
		dprint("rejected already on map\n");
		next;
	    }

	    # 4. the piece must not exit to a space that causes the extent to be >4 in either X or Y
	    my $newloc = $this->LocOfDirPlusCurrent($odir);
	    my $newextent = $this->ExtentPlusTile($newloc->{X},$newloc->{Y});
	    if ($newextent->{MAXX} - $newextent->{MINX} + 1 > 4)
	    {
		dprint("reject new extent X > 4\n");
		next;
	    }
	    if ($newextent->{MAXY} - $newextent->{MINY} + 1 > 4)
	    {
		dprint("reject new extent Y > 4\n");
		next;
	    }

	    if ($this->{PATHINDEX} != length($path)-1)
	    {
		# 5. unless it is the last piece, it must not turn into a space that has another tile in it
		if (exists($this->{USEDSPACES}->{$newloc->{X},$newloc->{Y}}))
		{
		    dprint("reject path turns on itself\n");
		    next;
		}
	    }
	    else
	    {
		# 6. if it is the last piece, it _must_ turn into a space that 
		# 6a. has a tile in it
		# 6b. has the first piece in it
		# 6c. has a DIRS that opposes the new FROMDIR
		if ($newloc->{X} != $this->{TILEPATH}->[0]->{X} ||
		    $newloc->{Y} != $this->{TILEPATH}->[0]->{Y} ||
		    index($this->{TILEPATH}->[0]->{DIRS},Opp($odir)) == -1)
		{
		    dprint("reject final fails to close\n");
		    next;
		}
	    }
	}

	dprint("success!\n");
	
	# If we get here, is a valid piece, add it to a clone and place the clone
	# in the queue.

	if ($this->{PATHINDEX} == 0)
	{
	    my $newmap1 = $this->Clone();
	    $newmap1->Add($piece,substr($piece->{DIRS},0,1));
	    push(@queue,$newmap1);
	    my $newmap2 = $this->Clone();
	    $newmap2->Add($piece,substr($piece->{DIRS},1,1));
	    push(@queue,$newmap2);
	}
	else
	{
	    my $newmap = $this->Clone();
	    $newmap->Add($piece,$odir);
	    push(@queue,$newmap);
	}
    }
}

sub IsComplete
{
    my ($this) = @_;
    return $this->{PATHINDEX} == length($path);
}


# a cell is three lines high by 5 characters wide, thus:
#  |
#-xKC-
#  |
# (last character wide is a space)
# x = hex digit 0-f
# (replace | and - characters with spaces if path does not go that direction)

sub Show
{
    my ($this) = @_;
    my $extent = $this->Extent();
    for (my $j = $extent->{MINY} ; $j <= $extent->{MAXY} ; $j++)
    {
	for (my $i = $extent->{MINX} ; $i <= $extent->{MAXX} ; $i++)
	{
	    if (!exists $this->{USEDSPACES}->{$i,$j})                     { print "     "; }
	    elsif (index($this->{USEDSPACES}->{$i,$j}->{DIRS},"U") == -1) { print "     "; }
	    else                                                          { print "  |  "; }
	}
	print "\n";

	for (my $i = $extent->{MINX} ; $i <= $extent->{MAXX} ; $i++)
	{
	    if (!exists $this->{USEDSPACES}->{$i,$j})                     { print "     "; }
	    else
	    {
		if (index($this->{USEDSPACES}->{$i,$j}->{DIRS},"L") != -1) {print "-"; }
		else { print " "; }

		printf("%x",$this->{USEDSPACES}->{$i,$j}->{PATHINDEX});
		print $this->{USEDSPACES}->{$i,$j}->{NAME};

		if (index($this->{USEDSPACES}->{$i,$j}->{DIRS},"R") != -1) {print "-"; }
		else { print " "; }
	    }
	}
	print "\n";

	for (my $i = $extent->{MINX} ; $i <= $extent->{MAXX} ; $i++)
	{
	    if (!exists $this->{USEDSPACES}->{$i,$j})                     { print "     "; }
	    elsif (index($this->{USEDSPACES}->{$i,$j}->{DIRS},"D") == -1) { print "     "; }
	    else                                                          { print "  |  "; }
	}
	print "\n";
    }
}

package main;


push(@queue,new Map());

while(@queue)
{
#    print "Queue Count: ", scalar (@queue),"\n";
    my $item = pop(@queue);

#    print "----\n";
#    $item->Show();
#    print "====\n";
#    ShowDataStructure::Show($item);
#    print "||||\n";


    my $status = $item->Operate();
    if ($item->IsComplete())
    {
	$item->Show();
    }
}
