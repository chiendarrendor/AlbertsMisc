package RearState;

sub new 
{
    my ($class,$from,$to) = @_;
    my $this = {};
    bless $this,$class;
    @{$this->{STATE}} = @$from;
    @{$this->{TO}} = @$to;
    $this->{DEPTH} = 0;
    return $this;
}
sub CanonicalKey 
{
    my ($this) = @_;
    return join(",",@{$this->{STATE}});
}
sub DisplayString 
{
    my ($this) = @_;
    return $this->CanonicalKey()."\n";
}
sub Move 
{
    my ($this) = @_;
    return $this->{MOVE} . '(' . $this->Grade() . ')';
}
sub Parent 
{
    my ($this) = @_;
    return $this->{PARENT};
}

sub WinGrade
{
    my ($this) = @_;
    return scalar @{$this->{TO}} + 1;
}

sub Grade 
{
    my ($this) = @_;
    my $result = 0;

    my $len = @{$this->{STATE}};
    my %realadjacencies;
    $realadjacencies{"A",$this->{STATE}->[0]} = 1;
    $realadjacencies{$this->{STATE}->[$len-1],"Z"} = 1;
    for (my $i = 0 ; $i < $len - 1; ++$i)
    {
	$realadjacencies{$this->{STATE}->[$i],$this->{STATE}->[$i+1]} = 1;
	$realadjacencies{$this->{STATE}->[$i+1],$this->{STATE}->[$i]} = 1;
    }

    ++$result if exists $realadjacencies{"A",$this->{TO}->[0]};
    ++$result if exists $realadjacencies{$this->{TO}->[$len-1],"Z"};
    for (my $i = 0 ; $i < $len - 1; ++$i)
    {
	++$result if exists $realadjacencies{$this->{TO}->[$i],
					     $this->{TO}->[$i+1]};
    }
    return $result;
}




sub AdjWinGrade 
{
    my ($this) = @_;

    # so, there's 1 less pair than the length of the TO array.
    # and we're giving correct orientation 2 points, so
    # the equation is 2(len-1);


    return 2*(scalar @{$this->{TO}} - 1);
}

sub AdjGrade 
{
    my ($this) = @_;
    my $result = 0;
    return -1 if ($this->{DEPTH} >= @{$this->{STATE}});

    my %index;
    for (my $i = 0 ; $i < @{$this->{STATE}} ; ++$i)
    {
	$index{$this->{STATE}->[$i]} = $i;
    }

    for (my $i = 0 ; $i < @{$this->{TO}} - 1 ; ++$i)
    {
	my $lindex = $index{$this->{TO}->[$i]};
	my $rindex = $index{$this->{TO}->[$i+1]};

	$result += 2 if $rindex == $lindex + 1;
	$result += 1 if $lindex == $rindex + 1;
    }
    return $result;
}

sub Successors 
{
    my ($this) = @_;
    my @result;
    # we need to find all intervals of length > 2.
    # i is the start index of an interval.
    for (my $i = 0 ; $i < @{$this->{STATE}} - 1 ; ++$i)
    {
	# j is the end index (inclusive) of an interval
	for (my $j = $i + 1 ; $j < @{$this->{STATE}} ; ++$j)
	{
	    my $ns = new RearState($this->{STATE},$this->{TO});
	    $ns->{PARENT} = $this->CanonicalKey();
	    $ns->{MOVE} = $i . "," . $j;
	    $ns->{DEPTH} = $this->{DEPTH} + 1;
	    @temp = @{$ns->{STATE}}[$i .. $j];
	    @temp = reverse(@temp);
	    @{$ns->{STATE}}[$i .. $j] = @temp;
	    push @result,$ns;
	}
    }
    return @result;
}

1;
