BEGIN { push @INC,"../../Common/Perl"; }

use Astar;

package Slider;

#xAABBCCx
#xADBBECx
#xDDFFEEx
#...FF...
#xGGxx..x
#xGGxx..x

my $initial = "xAABBCCx/xADBBECx/xDDFFEEx/...FF.../xGGxx..x/xGGxx..x";
my $goal    = "x......x/x......x/x......x/......../x..xxGGx/x..xxGGx";
my $gpiece = "G";

my @tiles=('A','B','C','D','E','F','G');
my @dirs =('U','D','L','R');
my $width = 8;
my $height = 6;

my %goaldata;
my $goalvalue;

# do a breath first search through all the possible places where
# the goal piece can be on an empty board, remembering the 
# depth (at the goal is depth 0)
# once we find the largest depth, alter all remembered depths to be
# largestdepth - depth
#
sub BuildGoalData
{
    my @wqueue;
    my $depth = 0;
    push @wqueue,[$depth,$goal];
    while(@wqueue) {
	my $item = shift @wqueue;
	next if exists $goaldata{$item->[1]};
	$depth = $item->[0];
	$goaldata{$item->[1]} = $depth;
	for my $dir (@dirs) {
	    my $nd = MoveOnString($item->[1],$gpiece,$dir);
	    next unless $nd;
	    push @wqueue,[$depth+1,$nd];
	}
    }
    for my $key (keys %goaldata) {
	$goaldata{$key} = $depth - $goaldata{$key};
    }
    $goalvalue = $depth;
}


sub new
{
    my ($class) = @_;
    my $this = {};
    bless $this,$class;
    $this->{KEY} = $initial;
    $this->{DEPTH} = 0;
    return $this;
}

sub CanonicalKey 
{
    my ($this) = @_;
    return $this->{KEY};
}

sub AtIndex
{
    my ($x,$y) = @_;
    return $y * ($width+1) + $x;
}

sub AlterString
{
    my ($x,$y,$string,$nval) = @_;
    substr($string,AtIndex($x,$y),1) = $nval;
    return $string;
}

sub GetString
{
    my ($x,$y,$string) = @_;
    return substr($string,AtIndex($x,$y),1);
}

sub At
{
    my ($this,$x,$y) = @_;
    return GetString($x,$y,$this->{KEY});
}

sub InDir
{
    my ($x,$y,$dir) = @_;
    return ($x+1,$y) if $dir eq 'R';
    return ($x-1,$y) if $dir eq 'L';
    return ($x,$y-1) if $dir eq 'U';
    return ($x,$y+1) if $dir eq 'D';
}

sub InBounds
{
    my ($x,$y) = @_;
    return 0 if $x < 0 || $x >= $width;
    return 0 if $y < 0 || $y >= $height;
    return 1;
}

# determines if the given key string has open space in the given
# direction for the given tile.  if so, return a new string
# with the move executed
# if not, return undef
sub MoveOnString
{
    my ($instring,$piece,$dir) = @_;
    # make sure that there is a valid space in the given direction
    # for every cell of the tile
    for (my $x = 0 ; $x < $width; ++$x) {
	for (my $y = 0 ; $y < $height ; ++$y) {
	    next unless GetString($x,$y,$instring) eq $piece;
	    my ($nx,$ny) = InDir($x,$y,$dir);
	    return undef unless InBounds($nx,$ny);
	    my $np = GetString($nx,$ny,$instring);
	    return undef unless $np eq '.' || $np eq $piece;
	}
    }
    # if we get here, a move is possible.
    # move stage 1.  clear the space where the tile was
    my $result = $instring;
    for (my $x = 0 ; $x < $width; ++$x) {
	for (my $y = 0 ; $y < $height ; ++$y) {
	    next unless GetString($x,$y,$instring) eq $piece;
	    $result = AlterString($x,$y,$result,'.');
	}
    }
    # move stage 2. put the piece in the new place.
    for (my $x = 0 ; $x < $width; ++$x) {
	for (my $y = 0 ; $y < $height ; ++$y) {
	    next unless GetString($x,$y,$instring) eq $piece;
	    my ($nx,$ny) = InDir($x,$y,$dir);
	    $result = AlterString($nx,$ny,$result,$piece);
	}
    }
    return $result;
}


# determines if the given piece has
# open space in the given direction
# if so, execute the move on KEY and return 1
# otherwise, return 0
sub DoMove
{
    my ($this,$piece,$dir) = @_;
    my $pr = MoveOnString($this->{KEY},$piece,$dir);
    return 0 unless $pr;
    $this->{KEY} = $pr;
    return 1;
}


sub Successors
{
    my ($this) = @_;
    my @result;
    
    for my $p (@tiles) {
	for my $d (@dirs) {
	    my $nst = new Slider();
	    $nst->{KEY} = $this->{KEY};
	    $nst->{PARENT} = $this->CanonicalKey();
	    $nst->{MOVE} = $p . $d;
	    $nst->{DEPTH} = $this->{DEPTH} + 1;
	    next unless $nst->DoMove($p,$d);
	    push @result, $nst;
	}
    }
    return @result;
}

sub WinGrade
{
    return $goalvalue;
}


sub Grade
{
    my ($this) = @_;
    my $key = $this->{KEY};
    eval "\$key =~ tr/x.\\/$gpiece/./c";
    return $goaldata{$key};
}

sub DisplayString
{
    my ($this) = @_;
    return join("\n",split("/",$this->{KEY})),"\n";
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

sub Depth
{
    my ($this) = @_;
    return $this->{DEPTH};
}

package main;

#$s = new Slider();
#print $s->DisplayString();

#print "----\n";

#@succs = $s->Successors();
#for $ss (@succs) {
#    print $ss->DisplayString();
#    print $ss->Move(),"\n";
#    print "\n";
#}

Slider::BuildGoalData();
Astar::Astar(new Slider(),1);
