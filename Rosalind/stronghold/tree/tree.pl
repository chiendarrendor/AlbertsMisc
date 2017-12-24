die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$count = <FD>;
$count =~ s/\r?\n$//;
for (my $i = 1 ; $i <= $count ; ++$i)
{
    $nodeid{$i} = [$i];
}

while(<FD>)
{
    $_ =~ s/\r?\n$//;
    ($from,$to) = split(" ",$_);
    next if $nodeid{$from} eq $nodeid{$to};
    push @{$nodeid{$from}},@{$nodeid{$to}};
    for $ti (@{$nodeid{$to}})
    {
	$nodeid{$ti} = $nodeid{$from};
    }
}

close FD;


for $k (keys %nodeid)
{
    next if exists $seen{$k};
    ++$gcount;
    for $i (@{$nodeid{$k}}) { $seen{$i} = 1; }
}

print $gcount-1;
print "\n";






