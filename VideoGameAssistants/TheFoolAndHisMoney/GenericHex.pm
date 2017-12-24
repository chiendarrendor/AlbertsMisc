package GenericHex;

# this class represents a generic hex grid
# with the following properties:
#
#  x:0 1 2 3 4 5 6 7 8 9 
# y:
#0   . 1 2 3 . . . . . .
#1  . 1 2 3 . . . . . .
#2   . 1 2 3 . . . . . .
#3  . . . . . . . . . .
#   0 1 2 3 4 5 6 7 8 9
# directions:
# 0: NORTHWEST
# 1: NORTHEAST
# 2: EAST
# 3: SOUTHEAST
# 4: SOUTHWEST
# 5: WEST

sub new
{
    my ($class) = @_;
    my $this = {};
    bless $this,$class;
    $this->{CELLS} = {};
    return $this;
}

sub clone
{
    my ($this,$isdeep) = @_;
    my $result = new GenericHex();

    for my $key (keys %{$this->{CELLS}})
    {
	my $cur = $this->{CELLS}->{$key};
	$result->{CELLS}->{$key} = $isdeep ? $cur->clone() : $cur;
    }
    return $result;
}

# accepting two kinds of inputs:
# a,b (external)
# or [ a,b ] produced by GetAdjacentCoordinate
# returns GetAdjacentCoordinate Form
sub GetXY
{
    my($x,$y) = @_;
    if (ref $x eq 'ARRAY') { return $x; }
    return [$x,$y];
}

sub GetCellId
{
    my ($x,$y) = @_;
    my $cv = GetXY($x,$y);
    return $cv->[0] . '.' . $cv->[1];
}


sub GetCell
{
    my ($this,$x,$y) = @_;
    my $cellid = GetCellId($x,$y);
    if (exists $this->{CELLS}->{$cellid})
    {
	return $this->{CELLS}->{$cellid};
    }
    return undef;
}

sub SetCell
{
    my ($this,$cell,$x,$y) = @_;
    my $cellid = GetCellId($x,$y);
    $this->{CELLS}->{$cellid} = $cell;
}


sub ClearCell
{
    my ($this,$x,$y) = @_;
    my $cellid = GetCellId($x,$y);
    delete $this->{CELLS}->{$cellid};
}

sub GetAdjacentCoordinate
{
    my ($this,$dir,$x,$y) = @_;
    my $cv = GetXY($x,$y);
    if ($dir == 2) { ++$cv->[0]; return $cv; }
    if ($dir == 5) { --$cv->[0]; return $cv; }

    if (($dir == 1 || $dir == 3) && ($cv->[1]%2 == 0)) { ++$cv->[0]; }
    if (($dir == 0 || $dir == 4) && ($cv->[1]%2 == 1)) { --$cv->[0]; }
    if ($dir == 0 || $dir == 1) { --$cv->[1]; }
    if ($dir == 3 || $dir == 4) { ++$cv->[1]; }

    return $cv;
}

1;

