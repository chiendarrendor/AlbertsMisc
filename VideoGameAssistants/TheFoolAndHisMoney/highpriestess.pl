use Astar;

package GameState;

my $initial;
my $goal;
my @xforms;

sub SetInitial
{
    $initial = $_[0];
    die("bad initial state") unless $initial =~ /^[01]{12}$/;
}

sub SetGoal
{
    $goal = $_[0];
    die("bad goal state") unless $goal =~ /^[01]{12}$/;
}

sub SetXform
{
    my ($index,@ary) = @_;
    $xforms[$index] = \@ary;

    die("bad pos") unless $index >= 0 && $index <= 11;
    for (my $i = 0 ; $i < @arg ; ++$i)
    {
	die("bad pos") unless $arg[$i] >= 0 && $arg[$i] <= 11;
    }
}

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
    return $names[$this->{MOVE}];
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

if (@ARGV != 14)
{
    print "board:\n";
    print "   0    1    2    3    4    5\n";
    print "1 hipr magc star herm strn devl\n";
    print "^\n";
    print "0\n";
    print "v\n";
    print "1 hier empr char just deth lvrs\n";
    print "   6    7    8    9    10   11\n";
    print "\n";
    print "command line:\n";
    print "  12 comma separated lists of cards that move with\n";
    print "     card in that position\n";
    print "  1  12-character string of 0 and 1 of initial state\n";
    print "  1  12-character string of 0 and 1 of goal state\n";
    exit(1);
}

for (my $i = 0 ; $i < 12 ; ++$i)
{
    my @ar = split(",",$ARGV[$i]);
    GameState::SetXform($i,@ar);
}

GameState::SetInitial($ARGV[12]);
GameState::SetGoal($ARGV[13]);


my $start = new GameState();

Astar::Astar($start,1);
