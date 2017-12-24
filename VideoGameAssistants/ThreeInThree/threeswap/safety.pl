use Astar;

package Safety;

# bits: 0x001 1
#       0x002 2
#       0x004 3
#       0x008 4
#       0x010 5
#       0x020 6
#       0x040 7
#       0x080 8
#       0x100 9
# 0 = closed
# 1 = open

sub IsBitOn
{
    my ($key,$bit) = @_;
    return $key & ( 0x1 << ($bit+1));
}

sub ToggleBit
{
    my ($key,$bit) = @_;
    return $key ^ ( 0x1 << ($bit+1));
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

    for ($i = 1 ; $i <= 9 ; ++$i)
    {
	if (IsBitOn($this->{KEY},$i))
	{
	    $result .= "1";
	}
	else
	{
	    $result .= "0";
	}
    }

    return $result . "\n";
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
    return 9;
}

sub Grade()
{
    my ($this) = @_;
    my $i;
    my $result = 0;
    for ($i = 1 ; $i <= 9 ; ++$i)
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
    my ($this,$active,$o1,$o2,$c1,$c2) = @_;
    # 0 closed, 1 open

    my $ekey = $this->{KEY};
    my $move = $active;
    if (IsBitOn($ekey,$active))
    {
	$ekey = ToggleBit($ekey,$c1);
	$ekey = ToggleBit($ekey,$c2);
	$move .= " <-";
    }
    else
    {
	$ekey = ToggleBit($ekey,$o1);
	$ekey = ToggleBit($ekey,$o2);
	$move .= " ->";
    }
    $ekey = ToggleBit($ekey,$active);
    $result = new Safety($ekey,$move,$this->CanonicalKey());
    return $result;
}

sub Successors()
{
    my ($this) = @_;
    my @result;
    my $i;

    push @result,$this->Successor(1,6,9,4,5);
    push @result,$this->Successor(2,4,6,6,8);
    push @result,$this->Successor(3,1,5,6,9);
    push @result,$this->Successor(4,7,8,6,8);
    push @result,$this->Successor(5,7,8,3,8);
    push @result,$this->Successor(6,2,4,1,2);
    push @result,$this->Successor(7,1,3,3,5);
    push @result,$this->Successor(8,5,6,3,4);
    push @result,$this->Successor(9,2,3,5,7);

    return @result;
}

package main;

my $start = new Safety(0x0,"",undef);

Astar::Astar($start,1);
