die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");

my $first = <FD>;
$first =~ s/\r?\n$//;

while(<FD>)
{
    $_ =~ s/\r?\n$//;
    push @rest,$_;
}

for ($testlength = length($first) ; $testlength >= 1 ; --$testlength)
{
    for ($startindex = 0; $startindex < length($first) - $testlength + 1 ; ++$startindex)
    {
	my $tss = substr($first,$startindex,$testlength);
	
	$missing = 0;
	for $other (@rest)
	{
	    if (index($other,$tss) == -1)
	    {
		$missing = 1;
		last;
	    }
	}
	if ($missing == 0)
	{
	    print $tss,"\n";
	    exit(0);
	}
    }
}


