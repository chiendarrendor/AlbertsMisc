use Astar;

package GameState;

#           0     1     2     3     4     5     6
@letters=("bde","aiu","lrf","gno","iec","nsa","tme");
@initial=(   1,  1,     0,    2,    0,    2,    2);
@goal=   (   2,  0,     1,    1,    1,    1,   0);
@actors=([0,1],[1,2],[2,3],[3,6],[0,6],[3,4],[4,5],[5,6]);
$rotwidth = 3;
# state is array, value is index into corresponding letter string
# initial is: 2 0 1 1 1 1 1
# goal is:    2 0 1 1 1 1 0

sub CanonicalKey
{
    my ($this) = @_;
    my $result = "K";
    for (my $i = 0 ; $i < @letters ; ++$i)
    {
	$result .= $this->{STATE}->[$i];
    }
    return $result;
}

sub DisplayString
{
    my ($this) = @_;
    my $result;

    for (my $i = 0 ; $i < @letters ; ++ $i)
    {
	my $lidx = $this->{STATE}->[$i];
	$result .= substr(@letters[$i],$lidx,1);
    }
    return $result,"\n";
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
    return scalar @letters;
}

sub Grade()
{
    my ($this) = @_;
    my $result = 0;
    for (my $i = 0 ; $i < @letters ; ++$i)
    {
	my $lidx = $this->{STATE}->[$i];
	++$result if $lidx == $goal[$i];
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
	$this->{STATE} = [];
	for (my $i = 0 ; $i < @initial ; ++$i)
	{
	    $this->{STATE}->[$i] = $initial[$i];
	}
    }
    else
    {
	$this->{STATE} = [];
	for (my $i = 0 ; $i < @$state ; ++$i)
	{
	    $this->{STATE}->[$i] = $state->[$i];
	}
	$this->{KEY} = $key;
	$this->{MOVE} = $move;
	$this->{PARENT} = $parent;
    }
    return $this;
}

sub incrot
{
    my ($x) = @_;
    return ($x+1)%$rotwidth;
}


sub Successor
{
    my ($this,$actor) = @_;
    my $actref = $actors[$actor];
    my @tempar = @{$this->{STATE}};
    for (my $i = 0 ; $i < @$actref ; ++$i)
    {
	$tempar[$actref->[$i]] = incrot($tempar[$actref->[$i]]);
    }
    return new GameState(\@tempar,$actor,$this->CanonicalKey());
}


sub Successors()
{
    my ($this) = @_;
    my @result;
    
    for (my $i = 0 ; $i < @actors ; ++$i)
    {
	push @result,$this->Successor($i);
    }
    return @result;
}

package main;

my $start = new GameState();

Astar::Astar($start,1);
