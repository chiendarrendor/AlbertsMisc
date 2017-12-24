die("bad command line") unless @ARGV == 6;

$counts{AA_AA} = $ARGV[0];
$counts{AA_Aa} = $ARGV[1];
$counts{AA_aa} = $ARGV[2];
$counts{Aa_Aa} = $ARGV[3];
$counts{Aa_aa} = $ARGV[4];
$counts{aa_aa} = $ARGV[5];

sub Mendel
{
    my ($t1,$t2) = @_;
    my $dcount = 0;
    for (my $i = 0 ; $i < 2 ; ++$i)
    {
	my $c1 = substr($t1,$i,1);
	for (my $j = 0 ; $j < 2 ; ++$j)
	{
	    my $c2 = substr($t2,$j,1);
	    ++$dcount if $c1 eq "A" || $c2 eq "A";
	}
    }
    return $dcount / 4.0;
}

$numkids = 2;
$result = 0;

for $k (keys %counts)
{
    ($p1,$p2) = split("_",$k);
    $result += $counts{$k} * $numkids * Mendel($p1,$p2);
}

printf("%.3f\n",$result);
