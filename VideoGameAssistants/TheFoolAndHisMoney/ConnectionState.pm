package ConnectionState;
use ConnectionCell;
use GenericHex;
use ConnectionGuesser;

sub IsWord
{
    my ($tw) = @_;
    
    my $res = `grep '^$tw\$' wordsEn.txt | wc -l`;
    chomp $res;
    return $res;
}

sub IsPrefix
{
    my ($tw) = @_;
    
    my $res = `grep '^$tw' wordsEn.txt | wc -l`;
    chomp $res;
    return $res;
}



# argument is ref to array of
# strings, space separated items of
# ConnectionCell format where the
# nth element of the array is the nth row
# in the hex grid.  Exception:
# a '.' is an empty cell and a ConnectionCell 
# should not be created.
sub new
{
    my ($class,$aref) = @_;
    my $this = {};
    bless $this,$class;
    $this->{GRID} = new GenericHex();
    $this->{WIDTH} = 0;
    $this->{HEIGHT} = scalar @$aref;;

    for (my $y = 0 ; $y < @$aref ; ++$y)
    {
	my $line = $aref->[$y];
	$line =~ s/^\s+//;

	my @lar = split(/\s+/,$line);
	$this->{WIDTH} = scalar @lar if scalar @lar > $this->{WIDTH};

	for (my $x = 0 ; $x < @lar ; ++$x)
	{
	    next if ($lar[$x] eq '.');
	    $this->{GRID}->SetCell(new ConnectionCell($lar[$x]),$x,$y);
	}
    }
    return $this;
}
# NEXTDEPTH (can be null)
# WORD
# SENTENCE
# CURX,CURY (can be null)

sub clone
{
    my ($this) = @_;
    my $result = {};
    bless $result,ref $this;
    $result->{GRID} = $this->{GRID}->clone(1);
    $result->{WIDTH} = $this->{WIDTH};
    $result->{HEIGHT} = $this->{HEIGHT};
    $result->{WORD} = $this->{WORD};
    $result->{SENTENCE} = $this->{SENTENCE};
    $result->{NEXTDEPTH} = $this->{NEXTDEPTH} if exists $this->{NEXTDEPTH};
    $result->{CURX} = $this->{CURX} if exists $this->{CURX};
    $result->{CURY} = $this->{CURY} if exists $this->{CURY};
    
    return $result;
}


sub show
{
    my ($this) = @_;
    for (my $y = 0 ; $y < $this->{HEIGHT} ; ++$y)
    {
	print " " if $y % 2 == 0;
	for (my $x = 0 ; $x < $this->{WIDTH} ; ++$x)
	{
	    my $c = $this->{GRID}->GetCell($x,$y);
	    if (!$c) { print " "; }
	    else { $c->show(); }
	    print " ";
	}
	print "\n";
    }
}

# possible states
# 1) we don't know our next depth...ask for it, and go one deeper
# 2) we have not reached our needed depth yet...go one deeper
# 3) we have reached our depth:
#    a) clear needed depth
#    b) validate word against dictionary
#    c) if word exists, ask if user likes word
#    d) if yes, return self.
#
# when going deeper:
#   if we don't have a CURX,CURY, use all cells
#   otherwise, find the first unfilled cell in each direction
#     from CURX,CURY


sub GetCellList
{
    my ($this) = @_;
    my $result = [];
    if (!exists $this->{CURX})
    {
	for (my $y = 0 ; $y < $this->{HEIGHT} ; ++$y)
	{
	    for (my $x = 0 ; $x < $this->{WIDTH} ; ++$x)
	    {
		my $c = $this->{GRID}->GetCell($x,$y);
		next unless $c;
		next if $c->IsFull();
		push @$result,[$x,$y];
	    }
	}
    }
    else
    {
	for (my $d = 0 ; $d < 6 ; ++$d)
	{
	    my $cxy = [$this->{CURX},$this->{CURY}];
	    while(1)
	    {
		my $nxy = $this->{GRID}->GetAdjacentCoordinate($d,$cxy);
		my $nc = $this->{GRID}->GetCell($nxy);

		last unless $nc;
		if ($nc->IsFull())
		{
		    $cxy = $nxy;
		    next;
		}
		# ok if we get here, we have an nc, and it's not full.
		push @$result,$nxy;
		last;
	    }
	}
    }
    return $result;
}

sub GetCurWord
{
    my ($this) = @_;
    return substr($this->{WORD},0,$this->{NEXTDEPTH});
}


sub Process
{
    my ($this,$guesser) = @_;
    # case 1)
    if (!exists $this->{NEXTDEPTH})
    {
	print "from '",$this->{SENTENCE},"' next depth: ";

	my $gd = $guesser->GetNextDepth($this->{SENTENCE});
	if ($gd != -1)
	{
	    print $gd,"\n";
	    $this->{NEXTDEPTH} = $gd;
	}
	else
	{
	    my $nd = <STDIN>;
	    chomp $nd;
	    $this->{NEXTDEPTH} = $nd;
	}
    }

    if ($this->{NEXTDEPTH} <= length($this->{WORD}))
    {
	# we want to save a possible suffix for the next word.
	my $suffix = substr($this->{WORD},$this->{NEXTDEPTH},
			    length($this->{WORD})-$this->{NEXTDEPTH},'');

	delete $this->{NEXTDEPTH};
	return [] unless IsWord($this->{WORD});

	if (length($this->{SENTENCE}) != 0) { $this->{SENTENCE} .= " "; }
	$this->{SENTENCE} .= $this->{WORD};

	print "how's '",$this->{SENTENCE},"' ? ";

	my $gw = $guesser->GetKnownWord($this->{SENTENCE});
	my $r;
	if ($gw)
	{
	    $r = ($gw eq $this->{WORD}) ? 'y' : 'n';
	    print $r,"\n";
	}
	else
	{
	    $r = <STDIN>;
	    chomp $r;
	}

	# now that we're done with processing, let's
	# give the suffix back.
	$this->{WORD} = $suffix;

	if ($r eq 'y') { return [ $this ]; };
	return [];
    }

    # ok, if we get here, we have a NEXTDEPTH and the word length
    # hasn't caught up to us yet.

    # perf enhancement.  If we have a guess for this next
    # word, and our current word isn't a prefix of that
    # guess, let's just stop.
    my $cg = $guesser->GetKnownWord($this->{SENTENCE} . " a");
    return [] if ($cg && index($cg,$this->GetCurWord()) == -1);

    my $cellist = $this->GetCellList();
    my $result = [];
    
    for my $cellxy (@$cellist)
    {
	my $ns = $this->clone();
	my $c = $ns->{GRID}->GetCell($cellxy);
	++$c->{CURCOUNT};
	$ns->{WORD} .= $c->{TEXT};

	$ns->{CURX} = $cellxy->[0];
	$ns->{CURY} = $cellxy->[1];

	push @$result,$ns if IsPrefix($ns->GetCurWord());
    }

    return $result;
}

1;
    
