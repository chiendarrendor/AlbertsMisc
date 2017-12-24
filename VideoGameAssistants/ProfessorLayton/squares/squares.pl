
my @spaces = (
    "..... ",
    "......",
    ".. ...",
    " .....",
    "....  ",
    " .. . "
    );


my @coords;
my %clookup;
sub PresentCount
{
    return scalar keys %clookup; 
}

sub IsPresent
{
    my ($x,$y) = @_;
    return exists $clookup{$x . '_' . $y};
}

sub MakePresent
{
    my ($x,$y) = @_;
    $clookup{$x . '_' . $y} = 1;
}

sub ClearPresent
{
    my ($x,$y) = @_;
    delete $clookup{$x . '_' . $y};
}


for ($y = 0 ; $y < @spaces ; ++$y) {
    for ($x = 0 ; $x < length($spaces[$y]) ; ++$x) {
	next unless substr($spaces[$y],$x,1) eq '.';
	push @coords, [$x,$y];
	MakePresent($x,$y);
    }
}

my @squares;
for ($i = 0 ; $i < @coords ; ++$i) {
    for ($j = $i + 1 ; $j < @coords ; ++$j) {
	$x1 = $coords[$i]->[0];
	$y1 = $coords[$i]->[1];
	$x2 = $coords[$j]->[0];
	$y2 = $coords[$j]->[1];
	$dy = $y2 - $y1;
	$dx = $x2 - $x1; 
	
	# calculate points for one square
	$dx3 = $dy;
	$dy3 = -$dx;
	$x3 = $x2 + $dx3;
	$y3 = $y2 + $dy3;
	$x4 = $x3 - $dx;
	$y4 = $y3 - $dy;

	if (IsPresent($x3,$y3) && IsPresent($x4,$y4)){ 
	    push @squares, [$x1,$y1,$x2,$y2,$x3,$y3,$x4,$y4];
	}

	# other square
	$dx3 = -$dy;
	$dy3 = $dx;
	$x3 = $x2 + $dx3;
	$y3 = $y2 + $dy3;
	$x4 = $x3 - $dx;
	$y4 = $y3 - $dy;

	if (IsPresent($x3,$y3) && IsPresent($x4,$y4)){ 
	    push @squares, [$x1,$y1,$x2,$y2,$x3,$y3,$x4,$y4];
	}
    }
}

for $sq (@squares) {
    print join(",",@$sq),"\n";
}
print "count: ",scalar @squares,"\n";

DoSearch();


sub DoSearch
{
    print "PC: ",PresentCount(),"\n";
    return 1 if (PresentCount() == 0);
    for (my $i = 0 ; $i < @squares ; ++$i) {
	my $square = $squares[$i];
	next if !IsPresent($square->[0],$square->[1]);
	next if !IsPresent($square->[2],$square->[3]);
	next if !IsPresent($square->[4],$square->[5]);
	next if !IsPresent($square->[6],$square->[7]);
       
	ClearPresent($square->[0],$square->[1]);
	ClearPresent($square->[2],$square->[3]);
	ClearPresent($square->[4],$square->[5]);
	ClearPresent($square->[6],$square->[7]);
	
	if (DoSearch()) {
	    print join(",",@$square),"\n";
	    return 1;
	}

	MakePresent($square->[0],$square->[1]);
	MakePresent($square->[2],$square->[3]);
	MakePresent($square->[4],$square->[5]);
	MakePresent($square->[6],$square->[7]);

    }
    return 0;
}




	
	
