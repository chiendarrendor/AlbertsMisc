BEGIN { push @INC,"../common"; }
use codon;

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$total = <FD>;
$total =~ s/\r?\n$//;
while(<FD>)
{
    $_ =~ s/\r?\n$//;
    push @residues,$_;
}

close FD;

@residues = sort { $a <=> $b } @residues;

for ($i = 0 ; $i < @residues/2 ; ++$i)
{
    $a = $residues[$i];
    $b = $residues[@residues-1-$i];
    push @pairs, [$a,$b];
}

for ($i = 0 ; $i < @pairs ; ++$i)
{
    $adjs{$i . "_0" } = { PAIRID=>$i,VALUE=>$pairs[$i]->[0],NEXT=>[],KEY=>$i . "_0" };
    $adjs{$i . "_1" } = { PAIRID=>$i,VALUE=>$pairs[$i]->[1],NEXT=>[],KEY=>$i . "_1" };
}

for $k1 (keys %adjs)
{
    ($prefix1,$type1) = split("_",$k1);
    my $n1 = $adjs{$k1};
    for $k2 (keys %adjs)
    {
	($prefix2,$type2) = split("_",$k2);
	my $n2 = $adjs{$k2};
	next if $prefix1 eq $prefix2;
	next if $n1->{VALUE} >= $n2->{VALUE};
	

	$diff = $n2->{VALUE} - $n1->{VALUE};
	$amino = codon::WeightProtein($diff);
	$realw = codon::ProteinWeight($amino);
	next if abs($realw - $diff) > 1e-6;
	push @{$n1->{NEXT}},[$n2,$amino];
    }
}

#for $n (sort { $a->{VALUE} <=> $b->{VALUE} } values %adjs)
#{
#    print $n->{KEY},": ";
#    for $e (@{$n->{NEXT}})
#    {
#	print "(" , $e->[0]->{KEY} , "," , $e->[1] , ")";
#    }
#    print "\n";
#}

# initial queue entries can be any _0 node, or the (n-1)_1 node.
for ($i = 0 ; $i < @pairs ; ++$i)
{
    $n = $adjs{$i . '_0'};
    push @queue, { NODES=>[$n->{KEY}],PROTEIN=>"",SEENPAIRS=>{$n->{PAIRID}=>1} };
}
$n = $adjs{(scalar @queue-1) . "_1"};
push @queue, { NODES=>[$n->{KEY}],PROTEIN=>"",SEENPAIRS=>{$n->{PAIRID}=>1} };

while(@queue)
{
    $qi = shift @queue;
    $n = $adjs{$qi->{NODES}->[scalar @{$qi->{NODES}} - 1]};

    $haschild = 0;
    for $nextp (@{$n->{NEXT}})
    {
	$nextnode = $nextp->[0];
	next if exists $qi->{SEENPAIRS}->{$nextnode->{PAIRID}};

	my $nq = {};
	@{$nq->{NODES}} = @{$qi->{NODES}};
	$nq->{PROTEIN} = $qi->{PROTEIN};
	%{$nq->{SEENPAIRS}} = %{$qi->{SEENPAIRS}};

	$nq->{SEENPAIRS}->{$nextnode->{PAIRID}} = 1;

	push @{$nq->{NODES}},$nextp->[0]->{KEY};
	$nq->{PROTEIN} .= $nextp->[1];
	
	push @queue,$nq;
	$haschild = 1;
    }
    push @done,$qi unless $haschild;



}

for $d (@done)
{
    next unless length($d->{PROTEIN}) == @pairs - 1;

    print $d->{PROTEIN},"\n";
    last;
}







