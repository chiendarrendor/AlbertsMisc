die("Bad command line: (numitems, numdups) \n") unless @ARGV == 2;
my $numitems = $ARGV[0];
my $numdups = $ARGV[1];


my $sum = 0;

for (my $i = 0 ; $i < 500 ; ++$i)
{
	my %idx;
	my $ctr = 0;

	while(1)
	{
		my $r = int(rand($numitems));
		++$ctr;
		++$idx{$r};
		last if $idx{$r} == $numdups;
	#	print join(",",%idx),"\n";
	}

	$sum += $ctr;
}

print "Avg: ",($sum/500.0),"\n";