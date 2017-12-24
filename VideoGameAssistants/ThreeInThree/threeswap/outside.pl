use Astar;

package Outside;

# 00 01 02 03 04 05 
# 06 07 08 09 10 11
# 12 13 14 15 16 17
# 18 19 20 21 22 23

# 0 = open
# 1 = closed

sub IsBitOn
{
    my ($key,$bit) = @_;
    return $key & ( 0x1 << $bit);
}

sub ToggleBit
{
    my ($key,$bit) = @_;
    return $key ^ ( 0x1 << $bit);
}


sub CanonicalKey
{
    my ($this) = @_;
    return "K" . $this->{KEY};
}

sub DisplayString
{
    my ($this) = @_;
    my $i;
    my $result;

    for ($i = 0 ; $i <= 23 ; ++$i)
    {
	if (IsBitOn($this->{KEY},$i))
	{
	    $result .= "#";
	}
	else
	{
	    $result .= ".";
	}

	if (($i % 6) == 5 ) 
	{
	    $result .= "\n";
	}
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

sub WinGrade()
{
    return 24;
}

sub Grade()
{
    my ($this) = @_;
    my $i;
    my $result = 0;
    for ($i = 0 ; $i < 24 ; ++$i)
    {
	if (IsBitOn($this->{KEY},$i))
	{
	    ++$result;
	}
    }
    return $result;
}

sub new
{
    my ($class,$key,$move,$parent) = @_;
    my $this = {};
    bless $this,$class;
    $this->{KEY} = $key;
    $this->{MOVE} = $move;
    $this->{PARENT} = $parent;
    return $this;
}



sub Successor
{
    my ($this,$result,$door,$dir,@odoors) = @_;
    if ($dir eq 'o' && !IsBitOn($this->{KEY},$door)) 
    {
	return;
    }

    if ($dir eq 'c' && IsBitOn($this->{KEY},$door))
    {
	return;
    }

    my $move;
    if ($dir eq 'c')
    {
	$move = "close " . $door;
    }
    else
    {
	$move = "open " . $door;
    }

    push @odoors,$door;
    my $i;
    my $key = $this->{KEY};

    for ($i = 0 ; $i < @odoors ; ++$i)
    {
	$key = ToggleBit($key,$odoors[$i]);
    }

    my $nobj;
    $nobj = new Outside($key,$move,$this->CanonicalKey());
    push @$result,$nobj;
}

sub Successors()
{
    my ($this) = @_;
    my @result;
    my $i;

    $this->Successor(\@result,7,'c',14,19);
    $this->Successor(\@result,7,'o',0,16,21);
    $this->Successor(\@result,8,'c',16,20);
    $this->Successor(\@result,8,'o',19,14,11);
    $this->Successor(\@result,9,'c',3,13,22);
    $this->Successor(\@result,9,'o',16,20);
    $this->Successor(\@result,10,'c',18,21,14);
    $this->Successor(\@result,10,'o',15,20);
    $this->Successor(\@result,13,'c',9,20);
    $this->Successor(\@result,13,'o',8,22,4);
    $this->Successor(\@result,14,'c',9,22);
    $this->Successor(\@result,14,'o',7,19,12);
    $this->Successor(\@result,15,'c',7,22);
    $this->Successor(\@result,15,'o',13,20,17);
    $this->Successor(\@result,16,'c',1,9,20);
    $this->Successor(\@result,16,'o',21,22);
    $this->Successor(\@result,19,'c',8,15,23);
    $this->Successor(\@result,19,'o',10,14);
    $this->Successor(\@result,20,'c',15,22);
    $this->Successor(\@result,20,'o',7,9,2);
    $this->Successor(\@result,21,'c',7,14);
    $this->Successor(\@result,21,'o',6,8,16);
    $this->Successor(\@result,22,'c',8,15,5);
    $this->Successor(\@result,22,'o',9,19);

    return @result;
}

package main;

my $start = new Outside(0x0,"",undef);

Astar::Astar($start,1);
