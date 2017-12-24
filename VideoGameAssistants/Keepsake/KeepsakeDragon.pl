use Astar;

package Board;

sub new
{
    my ($class,$other) = @_;

    my $this = {};
    bless $this,$class;


    if (ref($other) ne $class)
    {
	$this->{BOARD}->{0,0} = 'S';
	$this->{BOARD}->{1,0} = 'M';
	$this->{BOARD}->{2,0} = 'K';
	$this->{BOARD}->{3,0} = 'D';
	$this->{BOARD}->{0,1} = 'G';
	$this->{BOARD}->{1,1} = 'K';
	$this->{BOARD}->{2,1} = 'M';
	$this->{BOARD}->{3,1} = 'X';
	$this->{BOARD}->{0,2} = 'X';
	$this->{BOARD}->{1,2} = 'K';
	$this->{BOARD}->{2,2} = 'S';
	$this->{BOARD}->{3,2} = 'G';
	$this->{BOARD}->{0,3} = 'X';
	$this->{BOARD}->{1,3} = 'M';
	$this->{BOARD}->{2,3} = 'X';
	$this->{BOARD}->{3,3} = 'S';

	$this->{DEPTH} = 0;
    }
    else
    {
	foreach my $key (keys %{$other->{BOARD}})
	{
	    $this->{BOARD}->{$key} = $other->{BOARD}->{$key};
	}
    }

    return $this;
}

sub CanonicalKey
{
    my ($this) = @_;
    my $result = "";
    for (my $i = 0 ; $i < 4 ; ++$i)
    {
	for (my $j = 0 ; $j < 4 ; ++$j)
	{
	    $result .= $this->{BOARD}->{$i,$j};
	}
    }
    return $result;
}

sub DisplayString
{
    my ($this) = @_;
    my $result = "";
    for (my $y = 0 ; $y < 4 ; ++$y)
    {
	for (my $x = 0 ; $x < 4 ; ++$x)
	{
	    $result .= $this->{BOARD}->{$x,$y};
	}
	$result .="\n";
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
    return 5;
}

sub Grade
{
    my ($this) = @_;
    my $fx;
    my $fy;
    for (my $i = 0 ; $i < 4 ; ++$i)
    {
	for (my $j = 0 ; $j < 4 ; ++$j)
	{
	    if ($this->{BOARD}->{$i,$j} eq 'D')
	    {
		$fx = $i;
		$fy = $j;
	    }
	}
    }
    @dx = ( 1 , 2 , 1 , 0);
    @dy = ( 0 , 1 , 2 , 3);
    return $dx[$fx] + $dy[$fy];
}

sub Depth
{
    my ($this) = @_;
    return $this->{DEPTH};
}

my %swaps;
$swaps{'D','M'} = 1;
$swaps{'M','D'} = 1;
$swaps{'M','G'} = 1;
$swaps{'G','M'} = 1;
$swaps{'G','S'} = 1;
$swaps{'S','G'} = 1;
$swaps{'S','K'} = 1;
$swaps{'K','S'} = 1;

sub Swappable
{
    my ($this,$sx,$sy,$nx,$ny) = @_;

    return exists $swaps{$this->{BOARD}->{$sx,$sy},
			 $this->{BOARD}->{$nx,$ny}};
}

sub Swap
{
    my ($this,$sx,$sy,$nx,$ny) = @_;
    my $t = $this->{BOARD}->{$sx,$sy};
    $this->{BOARD}->{$sx,$sy} = $this->{BOARD}->{$nx,$ny};
    $this->{BOARD}->{$nx,$ny} = $t;
}

sub Successors
{
    my ($this) = @_;
    my @result;
    my $x;
    my $y;

    # downs
    for ($x = 0 ; $x < 4 ; ++$x)
    {
	for ($y = 0 ; $y < 3 ; ++$y)
	{
	    if ($this->Swappable($x,$y,$x,$y+1))
	    {
		my $newb = new Board($this);
		$newb->Swap($x,$y,$x,$y+1);
		$newb->{MOVE} = "$x,$y,D";
		$newb->{PARENT} = $this->CanonicalKey();
		$newb->{DEPTH} = $this->{DEPTH} + 1;
		push(@result,$newb);
	    }
	}
    }
    # rights
    for ($x = 0 ; $x < 3 ; ++$x)
    {
	for ($y = 0 ; $y < 4 ; ++$y)
	{
	    if ($this->Swappable($x,$y,$x+1,$y))
	    {
		my $newb = new Board($this);
		$newb->Swap($x,$y,$x+1,$y);
		$newb->{MOVE} = "$x,$y,R";
		$newb->{PARENT} = $this->CanonicalKey();
		$newb->{DEPTH} = $this->{DEPTH} + 1;
		push(@result,$newb);
	    }
	}
    }

    return @result;
}

package main;

$b = new Board();


Astar::Astar($b,1);   
	
