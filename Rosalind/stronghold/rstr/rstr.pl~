
die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$str = <FD>;
$str =~ s/\r?\n$//;

$probs = <FD>;
$probs =~ s/\r?\n$//;
@probs = split(" ",$probs);
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


my @result;

for $prob (@probs)
{
    $logprobhash = GetLogProbabilities($prob);
    my $result = 0;

    for (my $i = 0 ; $i < length($str) ; ++$i)
    {
	$result += $logprobhash->{substr($str,$i,1)};
    }
    push @result,$result;
}

for $r (@result)
{
    printf("%.3f ",$r);
}
print "\n";




