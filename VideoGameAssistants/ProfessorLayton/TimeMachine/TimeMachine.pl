use lib "C:/msys/1.0/home/Chien/Common/Perl";
use Astar;

package Tile;
# this package is representative of a tile on the board
# it will always have a tile-let at 0,0 relative, and the @coords
# argument is a list of $x,$y relative coords for additional tile-lets
# the tile item, when placed, knows where it is, how to mark the board's spaces,
# how to clear them on a 'lift', and can be asked if a particular placement
# is legal.
sub new
{
    my ($class,$board,$char,@coords) = @_;
    my $this = {};
    bless $this,$class;
    $this->{BOARD} = $board;
    $this->{CHAR} = $char;
    if (@coords % 2 != 0) { die("must have even number of coords!\n"); }

    # always has one.
    $this->{COORDS}->[0]->{X} = 0;
    $this->{COORDS}->[0]->{Y} = 0;

    my $cnum = 1;
    for(my $i = 0 ; $i < @coords ; $i+=2)
    {
	$this->{COORDS}->[$cnum]->{X} = $coords[$i];
	$this->{COORDS}->[$cnum]->{Y} = $coords[$i+1];
	++$cnum;
    }
    return $this;
}

sub CanDrop
{
    my ($this,$x,$y) = @_;

    # can't drop something already dropped
    if (exists $this->{X}) { die("can't try a drop of an already dropped Tile\n"); }

    for (my $i = 0 ; $i < @{$this->{COORDS}} ; ++$i)
    {
	my $pt = $this->{COORDS}->[$i];
	return 0 if ($pt->{X}+$x < 0 || $pt->{X}+$x >= 7);
	return 0 if ($pt->{Y}+$y < 0 || $pt->{Y}+$y >= 7);
	return 0 if ($this->{BOARD}->GetSpace($pt->{X}+$x,$pt->{Y}+$y) ne '.');
    }
    return 1;
}

sub Lift
{
    my ($this) = @_;
    if (!exists $this->{X}) { die ("Can't lift an already lifted Tile\n"); }

    for (my $i = 0 ; $i < @{$this->{COORDS}} ; ++$i)
    {
	my $pt = $this->{COORDS}->[$i];
	$this->{BOARD}->SetSpace($pt->{X} + $this->{X},$pt->{Y}+$this->{Y},'.');
    }
    delete $this->{X};
    delete $this->{Y};
}

sub Drop
{
    my ($this,$x,$y) = @_;
    if (!$this->CanDrop($x,$y))
    {
	return 0;
    }
    $this->{X} = $x;
    $this->{Y} = $y;
    for (my $i = 0 ; $i < @{$this->{COORDS}} ; ++$i)
    {
	my $pt = $this->{COORDS}->[$i];
	$this->{BOARD}->SetSpace($pt->{X} + $this->{X},$pt->{Y}+$this->{Y},$this->{CHAR});
    }
    return 1;
}

sub clone
{
    my ($this,$newboard) = @_;
    my @ar;

    if (!exists $this->{X}) { die("Can't clone a non-dropped Tile\n"); }

    for (my $i = 0 ; $i < @{$this->{COORDS}} ; ++$i)
    {
	my $pt = $this->{COORDS}->[$i];
	$ar[2*$i] = $pt->{X};
	$ar[2*$i+1] = $pt->{Y};
    }
    my $result = new Tile($newboard,$this->{CHAR},@ar);
    $result->Drop($this->{X},$this->{Y});
    return $result;
}

sub getX
{
    my ($this) = @_;
    return $this->{X};
}

sub getY
{
    my ($this) = @_;
    return $this->{Y};
}

package Board;

# puzzle: sliding block type:
#
#    .AA
#  ....AB
#  .C.BBB.
#  CC.R.DD
#  CE.F.DG
#   EEFFGG
#    .F.

# goal:
#
#   ...
# .XXXXX
# .XXXXX.
# .XXRXX.
# .XXXXX.
#  XXXXX.
#   ...

# empty:
# @@...@@
# ......@
# .......
# .......
# .......
# @......
# @@...@@


sub new
{
    my ($class) = @_;
    my $this = {};
    bless $this,$class;

    # fill out illegal spaces
    $this->SetSpace(0,0,' ');
    $this->SetSpace(1,0,' ');
    $this->SetSpace(5,0,' ');
    $this->SetSpace(6,0,' ');
    $this->SetSpace(6,1,' ');
    $this->SetSpace(0,5,' ');
    $this->SetSpace(0,6,' ');
    $this->SetSpace(1,6,' ');
    $this->SetSpace(5,6,' ');
    $this->SetSpace(6,6,' ');


    return $this;
}

sub clone
{
    my ($this) = @_;
    my $nb = new Board();

    $nb->{DEPTH} = $this->{DEPTH};
    $nb->{MOVE} = $this->{MOVE};
    $nb->{PARENT} = $this->{PARENT};

    for (my $i = 0 ; $i < @{$this->{TILES}} ; ++$i)
    {
	$nb->{TILES}->[$i] = $this->{TILES}->[$i]->clone($nb);
    }
    return $nb;
}

sub InitialPosition
{
    my ($this) = @_;
    

    #tiles
    $this->{TILES}->[0] = new Tile($this,'A',-1,0,0,1); 
    $this->{TILES}->[0]->Drop(4,0);
    $this->{TILES}->[1] = new Tile($this,'B',1,0,2,0,2,-1);
    $this->{TILES}->[1]->Drop(3,2);
    $this->{TILES}->[2] = new Tile($this,'C',0,1,-1,1,-1,2);
    $this->{TILES}->[2]->Drop(1,2);
    $this->{TILES}->[3] = new Tile($this,'D',1,0,0,1);
    $this->{TILES}->[3]->Drop(5,3);
    $this->{TILES}->[4] = new Tile($this,'E',0,1,1,1);
    $this->{TILES}->[4]->Drop(1,4);
    $this->{TILES}->[5] = new Tile($this,'F',-1,0,-1,-1,-1,1);
    $this->{TILES}->[5]->Drop(4,5);
    $this->{TILES}->[6] = new Tile($this,'G',-1,0,0,-1);
    $this->{TILES}->[6]->Drop(6,5);
    $this->{TILES}->[7] = new Tile($this,'R');
    $this->{TILES}->[7]->Drop(3,3);
}

sub SetSpace
{
    my ($this,$x,$y,$v) = @_;
    $this->{COORDS}->{$x,$y} = $v;
}

sub GetSpace
{
    my ($this,$x,$y) = @_;
    if (exists $this->{COORDS}->{$x,$y})
    {
	return $this->{COORDS}->{$x,$y};
    }
    return '.';
}

sub CanonicalKey
{
    my ($this) = @_;
    my $result;
    for (my $i = 0 ; $i < 7 ; ++$i)
    {
	for (my $j = 0 ; $j < 7 ; ++$j)
	{
	    $result .= $this->GetSpace($i,$j);
	}
    }
    return $result;
}

sub DisplayString
{
    my ($this) = @_;
    my $result;

    for (my $y = 0 ; $y < 7 ; ++$y)
    {
	for (my $x = 0 ; $x < 7 ; ++$x)
	{
	    $result .= $this->GetSpace($x,$y);
	}
	$result .= "\n";
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
    return 25;
}

sub Grade
{
    my ($this) = @_;
    my $count = 0;
    for (my $i = 1 ; $i <= 5 ; ++$i)
    {
	for (my $j = 1 ; $j <= 5 ; ++$j)
	{
	    if ($i == 2 && $j == 2)
	    {
		++$count if $this->GetSpace($i,$j) eq 'R';
	    }
	    else
	    {
		++$count if $this->GetSpace($i,$j) eq 'A' ||
		    $this->GetSpace($i,$j) eq 'B' ||
		    $this->GetSpace($i,$j) eq 'C' ||
		    $this->GetSpace($i,$j) eq 'C' ||
		    $this->GetSpace($i,$j) eq 'E' ||
		    $this->GetSpace($i,$j) eq 'F' ||
		    $this->GetSpace($i,$j) eq 'G';
	    }
	}
    }
    return $count;
}



sub Depth
{
    my ($this) = @_;
    return $this->{DEPTH};
}

sub TryAddSuccessor
{
    my ($this,$arref,$tileidx,$oldx,$oldy,$newx,$newy,$dirchar) = @_;
    my $curtile = $this->{TILES}->[$tileidx];

    $curtile->Lift();
    if (!$curtile->CanDrop($newx,$newy))
    {
	$curtile->Drop($oldx,$oldy);
	return;
    }
    $curtile->Drop($newx,$newy);
    $newboard = $this->clone();
    $newboard->{PARENT} = $this->CanonicalKey();
    $newboard->{DEPTH} = $this->{DEPTH}+1;
    $newboard->{MOVE} = $curtile->{CHAR} . $dirchar;

    push @$arref,$newboard;

    $curtile->Lift();
    $curtile->Drop($oldx,$oldy);
}

sub Successors
{
    my ($this) = @_;
    my @rar;

    for (my $i = 0 ; $i < @{$this->{TILES}} ; ++$i)
    {
	my $optile = $this->{TILES}->[$i];
	my $ox = $optile->getX();
	my $oy = $optile->getY();

	$this->TryAddSuccessor(\@rar,$i,$ox,$oy,$ox-1,$oy,'<');
	$this->TryAddSuccessor(\@rar,$i,$ox,$oy,$ox+1,$oy,'>');
	$this->TryAddSuccessor(\@rar,$i,$ox,$oy,$ox,$oy-1,'^');
	$this->TryAddSuccessor(\@rar,$i,$ox,$oy,$ox,$oy+1,'v');

	
    }
    return @rar;
}
	    
	


package main;

my $b = new Board();
$b->InitialPosition();
$| = 1;

Astar::Astar($b,1);
