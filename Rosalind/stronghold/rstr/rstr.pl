
die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$probs = <FD>;
$probs =~ s/\r?\n$//;
($ncount,$gcc) = split(" ",$probs);

$str = <FD>;
$str =~ s/\r?\n$//;

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
	C=>log10($gcc/2.0),
	G=>log10($gcc/2.0),
	A=>log10((1.0-$gcc)/2.0),
	T=>log10((1.0-$gcc)/2.0)
    };
}

$logprobhash = GetLogProbabilities($gcc);
my $pp = 0;

for (my $i = 0 ; $i < length($str) ; ++$i)
{
    $pp += $logprobhash->{substr($str,$i,1)};
}

$p = 10 ** $pp;

# find prob that it happens 0 times in n trials
# is a binomial distro
# p(K=k) = C(n,k) p^k (1-p)^(n-k)

$p0 = (1-$p) ** ($ncount);

printf("%.3f\n",1-$p0);
