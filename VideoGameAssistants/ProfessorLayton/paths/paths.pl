
use Solutions;

%verts = (
    A => [25],
    B => [30],
    C => [5],
    Ap => [2],
    Bp => [16],
    Cp => [1],
    1 => [Cp,7,9],
    2 => [Ap,4,11],
    3 => [13,4,12],
    4 => [5,3,2],
    5 => [C,13,4],
    6 => [7,14,18],
    7 => [6,15,1],
    8 => [27,9,15],
    9 => [10,8,1],
    10 => [11,9,16],
    11 => [10,17,2],
    12 => [23,3,17],
    13 => [5,3,20],
    14 => [6,19,30],
    15 => [7,8,26],
    16 => [Bp,27,10],
    17 => [12,11,29],
    18 => [26,24,6],
    19 => [24,21,14],
    20 => [30,21,13],
    21 => [22,20,19],
    22 => [21,25,23],
    23 => [22,29,12],
    24 => [25,19,18],
    25 => [A,24,22],
    26 => [28,18,15],
    27 => [28,8,16],
    28 => [29,27,26],
    29 => [28,17,23],
    30 => [B,20,14]
);

# validate

foreach my $v (keys %verts) {
    foreach my $e (@{$verts{$v}}) {
	die("bad hookup $v,$e, no $e") unless exists $verts{$e};
	my $found = 0;
	for (my $i = 0 ; $i < @{$verts{$e}} ; ++$i) {
	    if ($verts{$e}->[$i] eq $v) {
		$found = 1;
		break;
	    }
	}
	die("bad hookup $v,$e, no $v") unless $found;
    }
}


my $Asols = new Solutions("A","Ap",\%verts);
my $Bsols = new Solutions("B","Bp",\%verts);
my $Csols = new Solutions("C","Cp",\%verts);
print "A->Ap Solutions: ", scalar (@{$Asols->{SOLS}}),"\n";
print "B->Bp Solutions: ", scalar (@{$Bsols->{SOLS}}),"\n";
print "C->Cp Solutions: ", scalar (@{$Csols->{SOLS}}),"\n";

my $octr = 0;
my @ABpairs;
foreach $Apath (@{$Asols->{SOLS}}) {
    foreach $Bpath (@{$Bsols->{SOLS}}) {
	if (($cctr++ % 120000) == 0) { print ".\n"; }
	if ($Apath->Overlaps($Bpath)) {
	    next;
	}
	push @ABpairs,[$Apath,$Bpath];
    }
}

my $fctr = 0;
my @Triples;
print "\n";
print "AB nonoverlapping pair count: ",scalar @ABpairs,"\n";
foreach $ABpair (@ABpairs) {
    foreach $Cpath (@{$Csols->{SOLS}}) {
	if (($fctr++ % 45000) == 0) { print ".\n"; }
	next if $ABpair->[0]->Overlaps($Cpath);
	next if $ABpair->[1]->Overlaps($Cpath);
	push @Triples,[$ABpair->[0],$ABpair->[1],$Cpath];
    }
}
print "ABC nonoverlapping triple count: ",scalar @Triples,"\n";

my $t = @Triples[0];

print "A: ",join(",",@{$t->[0]->{PATH}}),"\n";
print "B: ",join(",",@{$t->[1]->{PATH}}),"\n";
print "C: ",join(",",@{$t->[2]->{PATH}}),"\n";






