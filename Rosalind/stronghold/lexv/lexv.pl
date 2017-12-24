die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$str = <FD>;
$str =~ s/\r?\n$//;
@symbols = split(" ",$str);

$scount = scalar @symbols;
$length = <FD>;
$length =~ s/\r?\n$//;
close FD;

my @indices;
for ($i = 0 ; $i < $length ; ++$i) { push @indices,0; }
for ($i = 0 ; $i < $length ; ++$i) { push @changed,1; }

$ocount = 0;
for ($i = 1 ; $i <= $length ; ++$i) { $ocount += $scount ** $i; }

for ($i = 0 ; $i < $ocount ; ++$i)
{
    my $res = "";
    for ($j = 0 ; $j < @indices ; ++$j)
    {
	$res .= $symbols[$indices[$j]];
	if ($changed[$j] == 1)
	{
	    $changed[$j] = 0;
	    last;
	}
    }
    print "$res\n";
    
    next unless $j + 1 == @indices;

    my $ci = $length-1;
    while(1)
    {
	++$indices[$ci];
	$changed[$ci] = 1;
	last unless $indices[$ci] == @symbols;
	$indices[$ci] = 0;
	--$ci;
    }
}


    



