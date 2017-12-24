use Astar;

# 01234567
#0
#1    N
#2   W E
#3    S
#4
#5
#6
#7

# escape at 0,0
# goblin starts at 0,5
# minotaur starts at 6,4
# internal walls:
# 00 : 01 |
# 40 : 41 |
# 61 : 62 |
# 52 : 62 -
# 43 : 44 |
# 04 : 14 -
# 54 : 64 -
# 64 : 74 -
# 74 : 75 |
# 25 : 35 -
# 25 : 26 |
# 56 : 66 -
# 56 : 57 |
# after goblin legal move (not off board, not through wall)
# minotaur moves twice to reduce offset to goblin: check horiz first, then vert

package State;

my %iwalls;
$iwalls{0,0} = "S"; $iwalls{4,0} = "S";
$iwalls{0,1} = "N"; $iwalls{4,1} = "N"; $iwalls{6,1} = "S";
$iwalls{5,2} = "E"; $iwalls{6,2} = "NW";
$iwalls{4,3} = "S";
$iwalls{0,4} = "E"; $iwalls{1,4} = "W"; $iwalls{4,4} = "N"; 
$iwalls{5,4} = "E"; $iwalls{6,4} = "WE"; $iwalls{7,4}="WS";
$iwalls{2,5} = "ES"; $iwalls{3,5} = "W"; $iwalls{7,5}="N";
$iwalls{5,6} = "ES"; $iwalls{6,6} = "W";
$iwalls{5,7} = "N";


sub IsInternalWall
{
    my ($sx,$sy,$dir) = @_;
    return 0 if (!exists $iwalls{$sx,$sy});
    return 0 if (index($iwalls{$sx,$sy},$dir) == -1);
    return 1;
}

sub IsExternalWall
{
    my ($sx,$sy,$dir) = @_;
    return 1 if ( $sx == 0 && $dir eq "W");
    return 1 if ( $sx == 7 && $dir eq "E");
    return 1 if ( $sy == 0 && $dir eq "N");
    return 1 if ( $sy == 7 && $dir eq "S");
    return 0;
}

sub IsWall
{
    my ($sx,$sy,$dir) = @_;
    return IsInternalWall($sx,$sy,$dir) || IsExternalWall($sx,$sy,$dir);
}


sub new 
{
    my ($class,$gx,$gy,$mix,$miy) = @_;
    my $this = {};
    bless $this,$class;

    if (ref($gx) eq "State")
    {
	$this->{GX} = $gx->{GX};
	$this->{GY} = $gx->{GY};
	$this->{MX} = $gx->{MX};
	$this->{MY} = $gx->{MY};
    }
    else
    {
	$this->{GX} = $gx;
	$this->{GY} = $gy;
	$this->{MX} = $mix;
	$this->{MY} = $miy;
	$this->{DEPTH} = 0;
    }
    return $this;
}

sub CanonicalKey
{
    my ($this) = @_;
    return $this->{MY} + $this->{MX}*8 + $this->{GY}*64 + $this->{GX}*512;
}

sub MoveGoblin
{
    my ($this,$dir) = @_;
    --$this->{GY} if $dir eq "N";
    ++$this->{GY} if $dir eq "S";
    ++$this->{GX} if $dir eq "E";
    --$this->{GX} if $dir eq "W";
}

sub MoveMinotaur
{
    my ($this,$dir) = @_;
    --$this->{MY} if $dir eq "N";
    ++$this->{MY} if $dir eq "S";
    ++$this->{MX} if $dir eq "E";
    --$this->{MX} if $dir eq "W";
}

sub IsCaught
{
    my ($this) = @_;
    return $this->{MX} == $this->{GX} && $this->{MY} == $this->{GY};
}

# determines the appropriate motion for a single step of the minotaur
sub ActivateMinotaur
{
    my ($this) = @_;

    if ($this->{MX} > $this->{GX} && !IsWall($this->{MX},$this->{MY},"W"))
    {
	$this->MoveMinotaur("W");
	return;
    }
    if ($this->{MX} < $this->{GX} && !IsWall($this->{MX},$this->{MY},"E"))
    {
	$this->MoveMinotaur("E");
	return;
    }
    if ($this->{MY} > $this->{GY} && !IsWall($this->{MX},$this->{MY},"N"))
    {
	$this->MoveMinotaur("N");
	return;
    }
    if ($this->{MY} < $this->{GY} && !IsWall($this->{MX},$this->{MY},"S"))
    {
	$this->MoveMinotaur("S");
	return;
    }
}


sub Successors
{
    my ($this) = @_;
    my @result;
    
    for my $dir ("N","S","E","W")
    {
	next if IsWall($this->{GX},$this->{GY},$dir);
	my $newstate = new State($this);
	$newstate->MoveGoblin($dir);

	$newstate->ActivateMinotaur();
	$newstate->ActivateMinotaur();
	next if $newstate->IsCaught();

	$newstate->{DIR} = $dir;
	$newstate->{PARENT} = $this->CanonicalKey();
	$newstate->{DEPTH} = $this->{DEPTH} + 1;

	push @result,$newstate;
    }
    return @result;
}

sub DisplayString
{
    my $string = "";
    my ($this) = @_;
    for (my $y = 0 ; $y < 8 ; ++$y)
    {
	for (my $x = 0 ; $x < 8 ; ++$x)
	{
	    if ($this->{GX} == $x && $this->{GY} == $y &&
		$this->{MX} == $x && $this->{MY} == $y)
	    {
		$string .=  "!";
	    }
	    elsif ($this->{GX} == $x && $this->{GY} == $y)
	    {
		$string .=  "G";
	    }
	    elsif ($this->{MX} == $x && $this->{MY} == $y)
	    {
		$string .=  "M";
	    }
	    else
	    {
		$string .=  ".";
	    }
	}
	$string .=  "\n";
    }
    return $string;
}

sub Move
{
    my ($this) = @_;
    return $this->{DIR};
}

sub Parent
{
    my ($this) = @_;
    return $this->{PARENT};
}

sub WinGrade
{
    return 16;
}

sub Grade
{
    my ($this) = @_;
    return 16 - $this->{GX} - $this->{GY};
}

sub Depth
{
    my ($this) = @_;
    return $this->{DEPTH};
}

package main;

$s = new State(0,5,6,4);

Astar::Astar($s,1);



	
    
    

    


