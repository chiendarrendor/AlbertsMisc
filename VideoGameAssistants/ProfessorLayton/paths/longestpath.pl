
use Solutions;
#              A
# c.....b.....a
# .#####.#####.
# .#####.#####.
# d..e..f..g..h
# .##.#####.##.
# .##.#####.##.
# .##i.....j##.
# .##.#####.##.
# .##.#####.##.
# k..l..m..n..o
# .#####.#####.
# .#####.#####.
# r.....q.....p
#B





%verts = (
    A => [a],
    B => [r],
    a => [A,b,h],
    b => [a,c,f],
    c => [b,d],
    d => [c,e,k],
    e => [d,f,i],
    f => [e,g,b],
    g => [f,h,j],
    h => [a,g,o],
    i => [e,j,l],
    j => [g,i,n],
    k => [d,l,r],
    l => [k,'m',i],
    'm' => [l,n,'q'],
    n => ['m',o,j],
    o => [h,n,p],
    p => [o,'q'],
    'q' => [p,r,'m'],
    r => [k,'q',B]
);

my %lengths = (
    A_a => 0,
    B_r => 0,
    a_b => 2,
    a_h => 1,
    b_c => 2,
    b_f => 1,
    c_d => 1,
    d_k => 2,
    d_e => 1,
    e_f => 1,
    e_i => 1,
    f_g => 1,
    g_h => 1,
    g_j => 1,
    h_o => 2,
    i_j => 2,
    i_l => 1,
    j_n => 1,
    k_l => 1,
    k_r => 1,
    'l_m' => 1,
    'm_n' => 1,
    'm_q' => 1,
    n_o => 1,
    o_p => 1,
    'p_q' => 2,
    'q_r' => 2
);

sub grade
{
    my ($path) = @_;
    my $result = 0;
    for my $k (keys %{$path->{USED}}) {
	die("no length $k") unless exists $lengths{$k};
	$result += $lengths{$k};
    }
    return $result;
}
 

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


my $sols = new Solutions("A","B",\%verts);

print "sol count: ", scalar @{$sols->{SOLS}} , "\n";

my $p0 = $sols->{SOLS}->[0];
print "Sol 0: ", join(",",@{$p0->{PATH}}),"\n";
print "Used keys: ",join(",",keys %{$p0->{USED}}),"\n";
print "Grade: ",grade($p0),"\n";

my $mg = 0;
my $mp;

for my $p (@{$sols->{SOLS}}) {
    $g = grade($p);
    if ($g > $mg) {
	$mg = $g;
	$mp = $p;
    }
}


print "Sol max: ", join(",",@{$mp->{PATH}}),"\n";
