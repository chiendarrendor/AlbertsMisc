
my %wkey;

sub swapletters
{
    my ($w,$idx) = @_;
    my @war = split(//,$w);
    if (!exists($wkey{$war[$idx],$idx}))
    {
	print "swap $idx on $w: ";
	my $nstr = <stdin>;
	chomp $nstr;
	my @nwar = split(//,$nstr);
	my $tidx;

	for ($tidx = 0 ; $tidx < 5 ; ++$tidx)
	{
	    next if ($tidx == $idx);
	    last if ($war[$tidx] ne $nwar[$tidx]);
	}
	if ($tidx < 5)
	{
	    $wkey{$war[$idx],$idx} = $tidx;
	    print "$war[$idx],$idx = $tidx\n";
	}
	else
	{
	    # if there's one other spot that has the same letter, that's what we're swapping with
	    my $dupcount = 0;
	    my $dupidx;

	    for ($tidx = 0 ; $tidx < 5 ; ++$tidx)
	    {
		next if ($tidx == $idx);
		if ($war[$idx] eq $war[$tidx])
		{
		    $dupcount++;
		    $dupidx = $tidx;
		}
	    }
	    if ($dupcount == 1)
	    {
		$wkey{$war[$idx],$idx} = $dupidx;
		print "$war[$idx],$idx = $tidx (DUP)\n";
	    }
	}
		


	return $nstr;
    }
    else
    {
	my $t = $war[$wkey{$war[$idx],$idx}];
	$war[$wkey{$war[$idx],$idx}] = $war[$idx];
	$war[$idx] = $t;
	my $res = join("",@war);

	print "input is $w, output is $res\n";
	return $res;
    }
}

$| = 1;
my $origword = $ARGV[0];
@war = split(//,$origword);
if (@ARGV != 1 || @war != 5)
{
    die("need a single five-letter word");
}

for ($i = 0 ; $i < 5 ; ++$i)
{
    for ($j = 0 ; $j < 5 ; ++$j)
    {
	for ($k = 0 ; $k < 5 ; ++$k)
	{
	    print "S:$i,$j,$k\n";
	    $w1 = swapletters($origword,$i);
	    $w2 = swapletters($w1,$j);
	    $w3 = swapletters($w2,$k);
	    print ">>>>>$i,$j,$k = $w3\n";
	}
    }
}

