use Astar;

package GameState;


my $initial = "111111111111";
my $goal = "000000000000";

# 0 = towards center, 1 = towards edge
#hipr magc star herm strn devl
# 0     1    2   3    4    5
# 6     7    8   9    10   11
#hier empr char just deth lvrs



my @xforms=
(
 [2,4], [3,7], [0,8], [4,9], [ 5,1 ], [6,1],
 [9,10],[3,11 ], [5,6], [1,10],  [2,5] , [2,3]
);


sub CanonicalKey
{
    my ($this) = @_;

    return $this->{STATE};
}

@names = 
(
 "hipr",
 "magc",
 "star",
 "herm",
 "strg",
 "devl",
 "hier",
 "empr",
 "char",
 "just",
 "deth",
 "lvrs"
);

sub DisplayString
{
    my ($this) = @_;
    my $result;

    for (my $i = 0 ; $i < length($this->{STATE}) ; ++$i)
    {
	if (substr($this->{STATE},$i,1) eq '1')
	{
	    $result .= uc($names[$i]) . " ";
	}
	else
	{
	    $result .= $names[$i] . " ";
	}
	if ($i == 5 || $i == 11) { $result .= "\n"; }
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
    return 12;
}

sub Grade()
{
    my ($this) = @_;
    my $result = 0;
    for (my $i = 0 ; $i < length($this->{STATE}) ; ++$i)
    {
	++$result if substr($this->{STATE},$i,1) eq substr($goal,$i,1);
    }
    return $result;
}

sub new
{
    my ($class,$state,$move,$parent) = @_;
    my $this = {};
    bless $this,$class;

    if (!defined $state)
    {
	$this->{STATE} = $initial;
    }
    else
    {
	$this->{STATE} = $state;
	$this->{KEY} = $key;
	$this->{MOVE} = $move;
	$this->{PARENT} = $parent;
    }
    return $this;
}

sub Successor
{
    my ($this,@ops) = @_;
    my $state = $this->{STATE};
    for (my $i = 0 ; $i < @ops; ++$i)
    {
	my $c =  substr($state,$ops[$i],1);
	substr($state,$ops[$i],1,$c eq '1' ? '0' : '1');
    }
    return new GameState($state,$ops[0],$this->CanonicalKey());
}
    



sub Successors()
{
    my ($this) = @_;
    my @result;

    for (my $i = 0 ; $i < @xforms ; ++$i)
    {
	push @result,$this->Successor($i,@{$xforms[$i]});
    }
    return @result;
}

package main;

my $start = new GameState();

Astar::Astar($start,1);
