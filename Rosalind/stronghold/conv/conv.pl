die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$s1 = <FD>;
$s1 =~ s/\r?\n$//;
$s2 = <FD>;
$s2 =~ s/\r?\n$//;
close FD;

@s1 = split(" ",$s1);
@s2 = split(" ",$s2);

# calculate the spectral convolution
for ($i = 0 ; $i < @s1 ; ++$i)
{
    for ($j = 0 ; $j < @s2 ; ++$j)
    {
	$v = $s1[$i]-$s2[$j];
	++$spec{$v};
    }
}

$maxrep = 0;

for $k (keys %spec)
{
    if ($spec{$k} > $maxrep)
    {
	$maxrep = $spec{$k};
	$maxk = $k;
    }
}

print $maxrep,"\n",abs($maxk),"\n";

