BEGIN { push(@INC,"../Common/Perl"); }

use Astar;

package Blacksmith;

sub new
{
    my ($class) = @_;
    my $i;
    my $j;
    my $this = {};
    bless $this,$class;

    for ($i = 0 ; $i < 6 ; ++$i)
    {
	for ($j = 0 ; $j < 6 ; $j++)
	{
	    $this->SetCell($i,$j,".");
	}
    }

    $this->{PX} = -1;
    $this->{PY} = -1;
    $this->{CX} = -1;
    $this->{CY} = -1;

    return $this;
}

# sets parent and depth correctly, move needs to be altered.
# clears all active items.
sub Clone
{
    my ($this) = @_;
    my $result = new Blacksmith();
    my $i;
    my $j;

    $result->{PX} = $this->{CX};
    $result->{PY} = $this->{CY};
    $result->{PARENT} = $this->CanonicalKey();
    $result->{MAXDEPTH} = $this->{MAXDEPTH};
    $result->{DEPTH} = $this->{DEPTH} + 1;

    for ($i = 0 ; $i < 6 ; ++$i)
    {
	for ($j = 0 ; $j < 6 ; $j++)
	{
	    $result->SetCell($i,$j,$this->GetCell($i,$j));
	}
    }

    return $result;
}

sub SetCell
{
    my ($this,$x,$y,$value) = @_;
    $this->{BOARD}->[$x][$y] = $value;
}

sub GetCell
{
    my ($this,$x,$y) = @_;
    return $this->{BOARD}->[$x][$y];
}

sub CanonicalKey
{
    my ($this) = @_;
    my $result;
    my $i;
    my $j;

    for ($i = 0 ; $i < 6 ; ++$i)
    {
	for ($j = 0 ; $j < 6 ; $j++)
	{
	    $result .= $this->GetCell($i,$j);
	    if ($i == $this->{CX} && $j == $this->{CY})
	    {
		$result .= '%';
	    }
	}
    }
    return $result;
}

sub Successors
{
    my ($this) = @_;
    my @result;
    my $i;
    my $j;
    my $k;
    my $l;
    my @succdests;
    my @nextsuccdests;
    my $newobj;
    my $newx;
    my $newy;

    if ($this->{CX} == -1 && $this->{CY} == -1)
    {
	for ($i = 0 ; $i < 6 ; ++$i)
	{
	    for ($j = 0 ; $j < 6 ; ++$j)
	    {
		my $newobj = $this->Clone();

		$newobj->{CX} = $i;
		$newobj->{CY} = $j;

		push (@result,$newobj);
	    }
	}
    }
    else
    {
	push(@result,$this->SuccessorsForCell($this->{CX},$this->{CY}));
    }

    return @result;
}

sub SuccessorsForCell
{
    my ($this,$x,$y) = @_;
    my @result;

    my @succdests = $this->GetSuccessorDestinations($x,$y);
	  
    for (my $k = 0 ; $k < @succdests ; ++$k)
    {
	my $newobj = $this->Clone();
	$newobj->{CX} = $succdests[$k]->{X};
	$newobj->{CY} = $succdests[$k]->{Y};

	$newobj->SetCell($x,$y,'?');

	push (@result,$newobj);
    }
    
    return @result;
}

# given a coordinate object, determine if the
# coordinate is 1. on the board at all, and 2. a non "." cell.
sub Validate
{
    my ($this,$coord) = @_;
    if ($coord->{X} < 0 || $coord->{X} > 5 ||
	$coord->{Y} < 0 || $coord->{Y} > 5 ||
	$this->GetCell($coord->{X},$coord->{Y}) eq ".")
    {
	return 0;
    }
    return 1;
}

# given an x,y coordinate, find the type of cell it is
# and return a set of all the legal, non "." spaces
# accessable from that spot.

sub GetSuccessorDestinations
{
    my ($this,$x,$y) = @_;
    my @result;
    my $type = $this->GetCell($x,$y);
    my $newcoord;


    if ($type eq "." || $type eq "?")
    {
    }
    elsif ($type eq "1" || $type eq "2" || $type eq "3" || $type eq "4")
    {
	my ($i,$j);

	for $i (-1,0,1)
	{
	    for $j (-1,0,1)
	    {
		next if ($i == 0 && $j == 0);

		$newcoord = {};
		$newcoord->{X} = $x + $i * $type;
		$newcoord->{Y} = $y + $j * $type;

		if ($this->Validate($newcoord))
		{
		    push(@result,$newcoord);
		}
	    }
	}
    }
    elsif ($type eq "K")
    {
	my ($i,$j,$k);

	foreach $i (-1,1)
	{
	    foreach $j (-1,1)
	    {
		foreach $k (0,1)
		{
		    my $dx = (2-$k)*$i;
		    my $dy = (1+$k)*$j;

		    $newcoord = {};
		    $newcoord->{X} = $x + $dx;
		    $newcoord->{Y} = $y + $dy;

		    if ($this->Validate($newcoord))
		    {
			push(@result,$newcoord);
		    }
		}
	    }
	}
    }
    elsif ($type eq "R" || $type eq "B" || $type eq "Q")
    {
	my ($i,$j);
	foreach $i (-1,0,1)
	{
	    foreach $j (-1,0,1)
	    {
		next if ($i == 0 && $j == 0);
		next if ($type eq "B" && ($i == 0 || $j == 0));
		next if ($type eq "R" && ($i != 0 && $j != 0));
		
		my $nx = $x;
		my $ny = $y;

	       
		# now we have starting point and the 
		# four or eight directions.  now, how to determine
		# if we can project that direction to an edge.

		do
		{
		    $nx = $nx + $i;
		    $ny = $ny + $j;
		} while ($nx >= 0 && $ny >= 0 && $nx <= 5 && $ny <= 5);
		
		$nx = $nx - $i;
		$ny = $ny - $j;

		if ($nx == $x && $ny == $y)
		{
		    next;
		}
		
		$newcoord = {};
		$newcoord->{X} = $nx;
		$newcoord->{Y} = $ny;

		if ($this->Validate($newcoord))
		{
		    push(@result,$newcoord);
		}
	    }
	}
    }


    return @result;
}



sub DisplayString
{
    my ($this) = @_;
    my $i;
    my $j;
    my $result;

    for ($i = 0 ; $i < 6 ; ++$i)
    {
	for ($j = 0 ; $j < 6 ; ++$j)
	{
	    if ($j == $this->{CX} && $i == $this->{CY})
	    {
		$result .= chr(0x1B) . "[32m";
	    }

	    $result .= $this->GetCell($j,$i);
	    $result .= " ";
	    $result .= chr(0x1B) . "[0m";
	}

	$result .= "\n";
    }
    return $result;
}

sub Move
{
    my ($this) = @_;
    my $result;

    if ($this->{PX} == -1)
    {
	$result = "starting ";
    }
    else
    {
	$result = $this->{PX} . "," . $this->{PY} . " to ";
    }

    $result .= $this->{CX} . "," . $this->{CY};

    return $result;
}

sub Parent
{
    my ($this) = @_;
    return $this->{PARENT};
}

sub WinGrade
{
    my ($this) = @_;
    my $result = 0;
    my $i;
    my $j;

    for ($i = 0 ; $i < 6 ; ++$i)
    {
	for ($j = 0 ; $j < 6 ; $j++)
	{
	    if ($this->GetCell($i,$j) ne ".")
	    {
		$result++;
	    }
	}
    }
    return ($this->{MAXDEPTH} < $result) ? $this->{MAXDEPTH} : $result;
}

sub Grade
{
    my ($this) = @_;
    return $this->{DEPTH};
}

package main;

my $board = new Blacksmith();
my $i = 0;
my $j;
my $line;
$|=1;

while($i != 6)
{
    
    print "line ",$i+1,": ";
    $line = <STDIN>;
    chomp $line;

    if ($line !~ /^([1234QBRK.]a?){6}$/)
    {
	print "Bad Line, try again.\n";
	next;
    }

    my $idx = 0;

    for ($j = 0 ; $j < 6 ; $j++)
    {
	$board->SetCell($j,$i,substr($line,$idx++,1));
	if (substr($line,$idx,1) eq 'a')
	{
	    $board->{CX} = $j;
	    $board->{CY} = $i;
	    $idx++;
	}
    }
    ++$i;
}


print "Original:\n",$board->DisplayString();
$board->{MAXDEPTH}=12;
$board->{DEPTH} = 0;

while(1)
{
    @result = Astar::Astar($board,0);
    if (@result == 0 || @result == 1)
    {
	print "no more moves possible.\n";
	last;
    }
    $sboard = $result[0];
    $board = $result[1];

    # clear all prior info
    undef $board->{PARENT};
    $board->{DEPTH} = 0;

    print "---\n";
    print "Move: ",$board->Move(),":\n";
    print $board->DisplayString();
    print "---\n";

    if ($sboard->{CX} != -1)
    {
	while(1)
	{
	    print "Replacement for ",$sboard->{CX},",",$sboard->{CY},": ";
	    $line = <STDIN>;
	    chomp $line;
	    
	    if ($line !~ /^[1234QBRK.]$/)
	    {
		print "Bad symbol, try again.\n";
		next;
	    }

	    $board->SetCell($sboard->{CX},$sboard->{CY},$line);
	    last;
	}
    }
}

