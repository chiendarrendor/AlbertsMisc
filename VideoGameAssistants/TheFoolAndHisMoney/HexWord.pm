package HexWord;

sub new
{
    my ($class,$word,@coords) = @_;
    my $this = [@coords];
    unshift @$this,$word;
    bless $this,$class;
    return $this;
}

sub Clone
{
    my ($this) = @_;
    return new HexWord(@$this);
}

sub Overlaps
{
    my ($this,$otherword) = @_;
    return 1 if $this->[0] eq $otherword->[0];

    for (my $i = 0 ; $i < 4 ; ++$i)
    {
	for (my $j = 0 ; $j < 4 ; ++$j)
	{
	    return 1 if 
		$this->[$i*2+1] == $otherword->[$j*2+1] &&
		$this->[$i*2+2] == $otherword->[$j*2+2];
	}
    }
    return 0;
}

sub Print
{
    my ($this) = @_;
    print $this->[0],": ";
    for (my $i = 0 ; $i < 4 ; ++$i)
    {
	print "(";
	print $this->[$i*2+1];
	print ",";
	print $this->[$i*2+2];
	print ")";
    }
    print "\n";
}




1;
