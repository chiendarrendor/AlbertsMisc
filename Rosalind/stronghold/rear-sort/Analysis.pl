die("bad command line") unless @ARGV == 1;
use RearState;
$size = $ARGV[0];

$np = 1;
for ($i = 2 ; $i <= $size ; ++$i ) { $np *= $i; }
for ($i = 1 ; $i <= $size ; ++$i) { push @base,$i; }

my %distances;
$rs = new RearState(\@base,\@base);
$distances{$rs->CanonicalKey()} = 0;
$cks[0] = [$rs->CanonicalKey()];

my $curd = 0;
while(scalar keys %distances < $np)
{
    $curar = $cks[$curd];
    $nextar = [];
    die("no items with depth $curd") unless @$curar > 0;
    for $curck (@$curar)
    {
	my @nar = split(",",$curck);
	$rs = new RearState(\@nar,\@nar);
	for $s ($rs->Successors())
	{
	    next if exists $distances{$s->CanonicalKey()};
	    $distances{$s->CanonicalKey()} = $curd+1;
	    push @$nextar,$s->CanonicalKey();
	}
    }
    $cks[$curd+1] = $nextar;
    ++$curd;
    print "depth $curd, count: ",scalar keys %distances,"\n";
}
print join("\n",@{$cks[$curd]});


