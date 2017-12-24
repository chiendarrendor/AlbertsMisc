die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$str = <FD>;
$str =~ s/\r?\n$//;
@symbols = split(" ",$str);
$scount = scalar @symbols;
$count = <FD>;
$count =~ s/\r?\n$//;
close FD;

my $ocount = $scount ** $count;

for ($i = 0 ; $i < $count ; ++$i) { push @indices,0; }

for ($i = 0 ; $i < $ocount ; ++$i)
{
    for ($j = 0 ; $j < @indices ; ++$j) 
    {
	print $symbols[$indices[$j]];
    }
    print "\n";

    my $ci = $count-1;
    while(1)
    {
	++$indices[$ci];
	last unless $indices[$ci] == @symbols;
	$indices[$ci] = 0;
	--$ci;
    }
}

    



