BEGIN { push @INC,"../../common/Perl"; }
use Astar;

package Shouting;

# ...###.##.
# .#.#......
# .#...#.##.
# .##.##.##.
# ..........
# #.####.##.
# ...#......

my @initial = (
    "...###.##.",
    ".#.#......",
    ".#...#.##.",
    ".##.##.##.",
    "..........",
    "#.####.##.",
    "...#......"
    );

my $goal;
my $width = 10;
my $height = 7;

sub CalcGoal
{
    for (my $y = 0 ; $y < $height ; ++$y) {
	for (my $x = 0 ; $x < $width ; ++$x) {
	    ++$goal if substr($initial[$y],$x,1) eq '.';
	}
    }
}

sub new
{
    my ($class) = @_;
    my $this = {};
    bless $this,$class;

    $this->{PLACEMENTS} = [];
    for (my $y = 0 ; $y < $height ; ++$y) {
	$this->{PLACEMENTS}->[$y] = $initial[$y];
    }
    
    $this->{SHOUTERS} = "332221111";
    $this->{DEPTH} = 0;
    $this->CalcKey();
    $this->CalcScore();
    return $this;
}

sub CalcKey
{
    my ($this) = @_;
    $this->{KEY} = "";
    for (my $y = 0 ; $y < $height ; ++$y) {
	$this->{KEY} .= $this->{PLACEMENTS}->[$y];
    }
}

sub CalcScore
{
    my ($this) = @_;
    $this->{GRADE} = 0;
    $this->{NOISY} = [];
    for (my $y = 0 ; $y < $height ; ++$y) {
	$this->{NOISY}->[$y] = $initial[$y];
    }
    for (my $y = 0 ; $y < $height ; ++$y) {
	for (my $x = 0 ; $x < $width ; ++$x) {
	    my $dist = substr($this->{PLACEMENTS}->[$y],$x,1);
	    next unless $dist =~ /[123]/;
	    for (my $i = 0 ; $i <= $dist;  ++$i) {
		my $nx = $x+$i;
		my $ny = $y;
		last if $nx < 0;
		last if $nx >= $width;
		last if substr($this->{PLACEMENTS}->[$ny],$nx,1) eq '#';
		next if substr($this->{NOISY}->[$ny],$nx,1) eq '*';
		substr($this->{NOISY}->[$ny],$nx,1) = '*';
		++$this->{GRADE};
	    }
	    for (my $i = 1 ; $i <= $dist;  ++$i) {
		my $nx = $x-$i;
		my $ny = $y;
		last if $nx < 0;
		last if $nx >= $width;
		last if substr($this->{PLACEMENTS}->[$ny],$nx,1) eq '#';
		next if substr($this->{NOISY}->[$ny],$nx,1) eq '*';
		substr($this->{NOISY}->[$ny],$nx,1) = '*';
		++$this->{GRADE};
	    }
	    for (my $i = 1 ; $i <= $dist;  ++$i) {
		my $nx = $x;
		my $ny = $y+$i;
		last if $ny < 0;
		last if $ny >= $height;
		last if substr($this->{PLACEMENTS}->[$ny],$nx,1) eq '#';
		next if substr($this->{NOISY}->[$ny],$nx,1) eq '*';
		substr($this->{NOISY}->[$ny],$nx,1) = '*';
		++$this->{GRADE};
	    }
	    for (my $i = 1 ; $i <= $dist;  ++$i) {
		my $nx = $x;
		my $ny = $y-$i;
		last if $ny < 0;
		last if $ny >= $height;
		last if substr($this->{PLACEMENTS}->[$ny],$nx,1) eq '#';
		next if substr($this->{NOISY}->[$ny],$nx,1) eq '*';
		substr($this->{NOISY}->[$ny],$nx,1) = '*';
		++$this->{GRADE};
	    }
	}
    }
}


sub Successors
{
    my ($this) = @_;
    my @result;
    return @result if length($this->{SHOUTERS}) == 0;
    my $curshouter = substr($this->{SHOUTERS},0,1);
    my $newshouters = substr($this->{SHOUTERS},1);
    my $newdepth = $this->{DEPTH} + 1;
    my $par = $this->CanonicalKey();
    for (my $y = 0 ; $y < $height ; ++$y) {
	for (my $x = 0 ; $x < $width ; ++$x) {
	    next unless substr($this->{PLACEMENTS}->[$y],$x,1) eq '.';
	    my $ni = {};
	    bless $ni,ref $this;
	    for (my $ny = 0 ; $ny < $height ; ++$ny) {
		$ni->{PLACEMENTS}->[$ny] = $this->{PLACEMENTS}->[$ny];
	    }
	    substr($ni->{PLACEMENTS}->[$y],$x,1) = $curshouter;
	    $ni->{SHOUTERS} = $newshouters;
	    $ni->{DEPTH} = $newdepth;
	    $ni->{PARENT} = $par;
	    $ni->{MOVE} = "$curshouter->($x,$y)";
	    $ni->CalcKey();
	    $ni->CalcScore();
	    push @result,$ni;
	}
    }
    return @result;
}

sub DisplayString
{
    my ($this) = @_;
    my $result = "";
    for (my $y = 0 ; $y < $height ; ++$y) {
	for (my $x = 0 ; $x < $width ; ++$x) {
	    my $p = substr($this->{PLACEMENTS}->[$y],$x,1);
	    my $n = substr($this->{NOISY}->[$y],$x,1);
	    if ($p eq '#') { $result .= "#"; }
	    elsif ($p =~ /[123]/) { $result .= $p; }
	    elsif ($n eq '*') { $result .= '*'; }
	    else { $result .= "."; }
	}
	$result .= "\n";
    }
    return $result;
}


sub WinGrade
{
    return $goal;
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

sub Grade
{
    my ($this) = @_;
    return $this->{GRADE};
}

sub Depth
{
    my ($this) = @_;
    return $this->{DEPTH};
}

sub CanonicalKey
{
    my ($this) = @_;
    return $this->{KEY};
}

package main;

Shouting::CalcGoal();

$s = new Shouting();

Astar::Astar($s,1);
