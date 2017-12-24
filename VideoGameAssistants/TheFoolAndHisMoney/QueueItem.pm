package QueueItem;

# properties of an item:
# * hash CELLS -- key is $x$y -- value is character there
# * array UNUSED -- list of lower-case characters that have not been inserted
# * array OPENLINES -- list of line ids that are not filled
# * ref GRIDDATA -- static data about the game 
#
# 0123
# abcd 4
# efgh 5
# ijkl 6
# mnop 7
my @linedata =
(
 [ "00","01","02","03" ],
 [ "10","11","12","13" ],
 [ "20","21","22","23" ],
 [ "30","31","32","33" ],
 [ "00","10","20","30" ],
 [ "01","11","21","31" ],
 [ "02","12","22","32" ],
 [ "03","13","23","33" ]
 );

sub GetWord
{
    my ($this,$lineid) = @_;
    my $result;
    for (my $i = 0 ; $i < 4 ; ++$i)
    {
	if (exists $this->{CELLS}->{$linedata[$lineid]->[$i]})
	{
	    $result .= $this->{CELLS}->{$linedata[$lineid]->[$i]};
	}
	else
	{
	    $result .= ".";
	}
    }
    return $result;
}

sub AddWord
{
    my ($this,$lineid,$word) = @_;
    for (my $i = 0 ; $i < 4 ; ++$i)
    {
	my $c = substr($word,$i,1);
	next if exists $this->{CELLS}->{$linedata[$lineid]->[$i]};
	$this->{CELLS}->{$linedata[$lineid]->[$i]} = $c;
	my $j;
	for ($j = 0 ; $j < @{$this->{UNUSED}};  ++$j)
	{
	    last if $this->{UNUSED}->[$j] eq $c;
	}
	splice(@{$this->{UNUSED}},$j,1);
    }
    my $i;
    for ($i = 0 ; $i < @{$this->{OPENLINES}} ; ++$i)
    {
	last if $lineid == $this->{OPENLINES}->[$i];
    }
    splice(@{$this->{OPENLINES}},$i,1);
}
	
sub PrintGrid
{
    my ($this) = @_;
    for (my $y = 0 ; $y < 4 ; ++$y)
    {
	for (my $x = 0 ; $x < 4 ; ++$x)
	{
	    if (exists $this->{CELLS}->{$x . $y})
	    {
		print $this->{CELLS}->{$x . $y} , " ";
	    }
	    else
	    {
		print ". ";
	    }
	}
	print "\n";
    }
}

sub IsFull
{
    my ($this) = @_;
    return (scalar keys %{$this->{CELLS}}) == 16;
}


my $count;
sub GetCount()
{
    return $count;
}


sub newFromUpper
{
    my ($class,$griddata,$letterref,$spaceref) = @_;
    my $this = {};
    bless $this,$class;
    ++$count;
    $this->{CELLS} = {};
    $this->{UNUSED} = [];
    @{$this->{UNUSED}} = @{$griddata->{LOWERCHARS}};
    $this->{OPENLINES} = [ 0,1,2,3,4,5,6,7];
    $this->{GRIDDATA} = $griddata;
    for (my $i = 0 ; $i < @$letterref; ++$i)
    {
	$this->{CELLS}->{$spaceref->[$i]->[0] . $spaceref->[$i]->[1]} = $letterref->[$i];
    }
    return $this;
}

sub clone
{
    my ($this) = @_;
    my $result = {};
    bless $result,ref $this;
    ++$count;
    %{$result->{CELLS}} = %{$this->{CELLS}};
    @{$result->{UNUSED}} = @{$this->{UNUSED}};
    @{$result->{OPENLINES}} = @{$this->{OPENLINES}};
    $result->{GRIDDATA} = $this->{GRIDDATA};
    return $result;
}

# looks at all open lines.  if a line is full, 
# look it up in GRIDDATA.  if that word is not found, return false.
# if it is found, remove that open line.
# if all open lines are either not full or found, return true;
sub Validate
{
    my ($this) = @_;
    my $newopen = [];

    my $numbad = 0;
    for my $line (@{$this->{OPENLINES}})
    {
	my $word = $this->GetWord($line);
	if ($word =~ /\./)
	{
	    push @$newopen,$line;
	    next;
	}
	# second argument can be empty because, if all letters
	# are full, we won't be ensuring that any new letters
	# are valid.
	my $words = $this->{GRIDDATA}->SearchWords($word,[]);
	if (@$words != 1)
	{
	    # this should be ok...state of an invalid QueueItem isn't important.
	    return 0;
	}
	# not putting the line id into newopen removes it.
    }
    $this->{OPENLINES} = $newopen;
    return 1;
}
    




1;

