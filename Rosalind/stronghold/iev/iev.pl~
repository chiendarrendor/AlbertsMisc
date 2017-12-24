die("bad command line") unless @ARGV == 3;

$counts{AA} = $ARGV[0];
$counts{Aa} = $ARGV[1];
$counts{aa} = $ARGV[2];
$tcount = $ARGV[0] + $ARGV[1] + $ARGV[2];

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

sub ProbChosen
{
    my ($t1,$t2) = @_;

    return 0.0 if $counts{$t1} <= 0;
    return 0.0 if $counts{$t2} <= 0;
    return 0.0 if $t1 eq $t2 && $counts{$t1} <= 1;

    my $p1 = $counts{$t1} / $tcount;
    my $p2 = ($counts{$t2} - ($t1 eq $t2 ? 1 : 0) ) / ($tcount - 1);

    return $p1 * $p2;
}



my $prob = 0;
for $first (AA,Aa,aa)
{
    for $second (AA,Aa,aa)
    {
	$prob += ProbChosen($first,$second) * Mendel($first,$second);
    }
}

printf("%.3f\n",$prob);
