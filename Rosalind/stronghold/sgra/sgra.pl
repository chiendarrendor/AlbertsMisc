BEGIN { push @INC,"../common"; }
use codon;

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
while(<FD>)
{
    $_ =~ s/\r?\n$//;
    push @residues,$_;
}

close FD;

for ($i = 0 ; $i < @residues ; ++$i)
{
    $adjs{$i} = { VALUE=>$residues[$i],NEXT=>[],KEY=>$i };
}

for ($k1 = 0 ; $k1 < @residues ; ++$k1)
{
    my $n1 = $adjs{$k1};
    for ($k2 = 0 ; $k2 < @residues ; ++$k2)
    {
	my $n2 = $adjs{$k2};
	next if $k1 eq $k2;
	next if $n1->{VALUE} >= $n2->{VALUE};

	$diff = $n2->{VALUE} - $n1->{VALUE};
	$amino = codon::WeightProtein($diff);
	$realw = codon::ProteinWeight($amino);
#	print "edging $k1,$k2: $diff $realw ($amino)->",abs($realw-$diff),"\n";
#	print "values: ",$n2->{VALUE}," - ",$n1->{VALUE},"\n";
	next if abs($realw - $diff) > 1e-4;
	push @{$n1->{NEXT}},[$n2,$amino];
    }
}

if (0)
{
for $n (sort { $a->{VALUE} <=> $b->{VALUE} } values %adjs)
{
    print $n->{KEY},": ";
    for $e (@{$n->{NEXT}})
    {
	print "(" , $e->[0]->{KEY} , "," , $e->[1] , ")";
    }
    print "\n";
}
}

# initial queue entries can be any _0 node, or the (n-1)_1 node.
for ($i = 0 ; $i < @residues ; ++$i)
{
    $n = $adjs{$i};
    push @queue, { NODES=>[$n->{KEY}],PROTEIN=>""};
}

while(@queue)
{
    $qi = shift @queue;
    $n = $adjs{$qi->{NODES}->[scalar @{$qi->{NODES}} - 1]};

    $haschild = 0;
    for $nextp (@{$n->{NEXT}})
    {
	$nextnode = $nextp->[0];

	my $nq = {};
	@{$nq->{NODES}} = @{$qi->{NODES}};
	$nq->{PROTEIN} = $qi->{PROTEIN};

	push @{$nq->{NODES}},$nextp->[0]->{KEY};
	$nq->{PROTEIN} .= $nextp->[1];
	
	push @queue,$nq;
	$haschild = 1;
    }
    push @done,$qi unless $haschild;



}

@done = sort { length($b->{PROTEIN}) <=> length($a->{PROTEIN}) } @done;


for $d (@done)
{
    print $d->{PROTEIN},"\n";
    last;
}







