
die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");

$slength = <FD>;
$slength =~ s/\r?\n$//;

$str = <FD>;
$str =~ s/\r?\n$//;

$probs = <FD>;
$probs =~ s/\r?\n$//;
(@probs) = split(" ",$probs);


close FD;

sub log10
{
    my $n = shift;
    return log($n) / log(10);
}

sub GetLogProbabilities
{
    my ($gcc) = @_;
    return  
    {
	C=>$gcc/2.0,
	G=>$gcc/2.0,
	A=>(1.0-$gcc)/2.0,
	T=>(1.0-$gcc)/2.0
    };
}

sub GetOProb
{
    my ($str,$gcc) = @_;
    my $logprobhash = GetLogProbabilities($gcc);
    my $pp = 1;
    
    for (my $i = 0 ; $i < length($str) ; ++$i)
    {
	$pp *= $logprobhash->{substr($str,$i,1)};
    }

    return $pp;
}

my $n = $slength - length($str) + 1;

for $prob (@probs)
{
    $r = GetOProb($str,$prob) * $n;
    printf("%.3f ",$r);
}
print "\n";
