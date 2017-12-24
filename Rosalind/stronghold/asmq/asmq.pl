
die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");

while(<FD>)
{
    $_ =~ s/\r?\n$//;    
    my $len = length($_);
    $contiglength{$len} += $len;
    $sumlength += $len;
}
close FD;

sub NStat
{
    my ($pct) = @_;
    my $goal = ($pct/100)*$sumlength;

    my $runningsum;
    my $nstatlen;
    for my $len (sort { $b <=> $a } keys %contiglength)
    {
	$nstatlen = $len;
	$runningsum += $contiglength{$len};
	last if $runningsum > $goal;
    }
    return $nstatlen;
}

print NStat(50)," ",NStat(75),"\n";


