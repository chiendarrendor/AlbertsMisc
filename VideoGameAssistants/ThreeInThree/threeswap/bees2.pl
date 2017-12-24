use Astar;

package Bees1;

#  0  1  2  3  4
#  5  6  7  8  9 
# 10 11 12 13 14

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

    for ($i = 0 ; $i < 15 ; ++$i)
    {
	if (IsBitOn($this->{KEY},$i))
	{
	    $result .= "1";
	}
	else
	{
	    $result .= "0";
	}
	if (($i % 5) == 4)
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
    return 15;
}

sub Grade()
{
    my ($this) = @_;
    my $i;
    my $result = 0;
    for ($i = 0 ; $i < 15 ; ++$i)
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
    my ($this,$active,$dir,$result,@others) = @_;
    # 0 closed, 1 open

    my $ekey = $this->{KEY};
    my $move = $active;

    if ($dir eq 'o' && IsBitOn($ekey,$active))
    {
	return;
    }

    if ($dir eq 'c' && !IsBitOn($ekey,$active))
    {
	return;
    }

    if ($dir eq 'o')
    {
	$move .= " open";
    }
    else
    {
	$move .= " close";
    }

    $ekey = ToggleBit($ekey,$active);

    my $i;
    for ($i = 0 ; $i < @others ; ++$i)
    {
	$ekey = ToggleBit($ekey,$others[$i]);
    }

    my $newone = new Bees1($ekey,$move,$this->CanonicalKey());
    push @$result,$newone;
}

sub Successors()
{
    my ($this) = @_;
    my @result;
    my $i;

    $this->Successor(0,'o',\@result,12);
    $this->Successor(0,'c',\@result,9);
    $this->Successor(1,'o',\@result,5);
    $this->Successor(1,'c',\@result,9,13);
    $this->Successor(2,'o',\@result,13);
    $this->Successor(2,'c',\@result,7);
    $this->Successor(3,'o',\@result,11);
    $this->Successor(3,'c',\@result,6);
    $this->Successor(4,'o',\@result,6,10);
    $this->Successor(4,'c',\@result,5);
    $this->Successor(5,'o',\@result,6);
    $this->Successor(5,'c',\@result,3,11);
    $this->Successor(6,'o',\@result,0,2);
    $this->Successor(6,'c',\@result,10);
    $this->Successor(7,'o',\@result,1,5);
    $this->Successor(7,'c',\@result,13);
    $this->Successor(8,'o',\@result,10);
    $this->Successor(8,'c',\@result,11);
    $this->Successor(9,'o',\@result,13);
    $this->Successor(9,'c',\@result,12);
    $this->Successor(10,'o',\@result,8);
    $this->Successor(10,'c',\@result,1);
    $this->Successor(11,'o',\@result,9);
    $this->Successor(11,'c',\@result,4);
    $this->Successor(12,'o',\@result,1,5);
    $this->Successor(12,'c',\@result,3);
    $this->Successor(13,'o',\@result,6);
    $this->Successor(13,'c',\@result,2);
    $this->Successor(14,'o',\@result,8,6);
    $this->Successor(14,'c',\@result,0);

    return @result;
}

package main;

my $start = new Bees1(0x0,"",undef);

Astar::Astar($start,1);
