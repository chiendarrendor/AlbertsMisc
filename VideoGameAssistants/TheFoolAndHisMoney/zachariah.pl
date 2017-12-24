use Astar;

package ZBoard;

# this class solves one card of the Zachariah puzzle, which is a
# 3x4 sliding puzzle, thus:
#  vvv
# >012<
# >345<
# >678<
# >9ab<
#  ^^^

sub new
{
    my ($class,@ary) = @_;
    my $this = {};
    bless $this,$class;
    $this->{GRID} = \@ary;
    return $this;
}

sub CanonicalKey
{
    my ($this) = @_;
    return join(",",@{$this->{GRID}});
}

sub OneSuccessor
{
    my ($this,$move,@indexlist) = @_;
    my $n = new ZBoard();
    $n->{MOVE} = $move;
    $n->{PARENT} = $this->CanonicalKey();
    $n->{GRID} = [];
    for (my $i = 0 ; $i < 12 ; ++$i)
    {
	$n->{GRID}->[$i] = $this->{GRID}->[$i];
    }
    my $t = $n->{GRID}->[$indexlist[0]];
    for (my $i = 0 ; $i < @indexlist-1 ; ++$i)
    {
	$n->{GRID}->[$indexlist[$i]] = $n->{GRID}->[$indexlist[$i+1]];
    }
    $n->{GRID}->[$indexlist[@indexlist-1]] = $t;
    return $n;
}


sub Successors
{
    my ($this) = @_;
    my @result;
    push(@result,$this->OneSuccessor("0D",0,3,6,9));
    push(@result,$this->OneSuccessor("1D",1,4,7,10));
    push(@result,$this->OneSuccessor("2D",2,5,8,11));
    push(@result,$this->OneSuccessor("0A",0,1,2));
    push(@result,$this->OneSuccessor("1A",3,4,5));
    push(@result,$this->OneSuccessor("2A",6,7,8));
    push(@result,$this->OneSuccessor("3A",9,10,11));
    return @result;
}


sub DisplayString
{
    my ($this) = @_;
    my $result = "";
    for ($i = 0 ; $i < 12 ; ++$i)
    {
	$result .= $this->{GRID}->[$i] . "\t";
	if ($i % 3 == 2) { $result .= "\n"; }
    }
    return $result;
}

sub Grade
{
    my ($this) = @_;
    my $result = WinGrade();
    for (my $i = 0 ; $i < 12 ; ++$i)
    {
	my $v = $this->{GRID}->[$i];
	my $dx = abs($v % 3 - $i % 3);
	my $dy = abs(int($v/3) - int($i/3));

	$result -= $dx;
	$result -= $dy;
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

# max dist between extrema times the number of tiles
sub WinGrade
{
    return 60;
}

package main;

my $f = new ZBoard(1,0,2,3,4,5,6,7,8,9,10,11);

Astar::Astar($f,1);

