



foreach my $i (1 ... 511)
{
	$count = 0;
	$sum = 0;
	$str = "";
	for my $k (1 ... 9)
	{
		if ((($i >> ($k-1)) & 0x1) == 1) 
		{
			$str .= $k;
			++$count;
			$sum += $k;
		}
	}
	next unless $count > 1;
	if (!exists $res{$count,$sum}) { $res{$count,$sum} = [] }
	unshift @{$res{$count,$sum}},$str;
}

($mylen,$mysum) = @ARGV[0..1];

for $key (keys %res)
{
	($count,$sum) = split ($;,$key);
	next unless $count == $mylen && $sum == $mysum;
	for $item (@{$res{$key}}) {
		print $item,"\n";
	}
}