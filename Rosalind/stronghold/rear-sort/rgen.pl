
use PermTransforms;

sub RevOn
{
    my ($ar,$start,$stop) = @_;
    my $t;
    while($start < $stop)
    {
	$t = $ar->[$start];
	$ar->[$start] = $ar->[$stop];
	$ar->[$stop] = $t;
	++$start;
	--$stop;
    }
}

my %tree;

# array hash is depth, source, first index, last index
$tree{0} = [0,-1,-1,-1];
my $pending = [0];
my $curdepth = 0;
my $width = PermTransforms::Width();


while($curdepth < $width)
{
    $newpending = [];
#    print "pending size: ",scalar @$pending,"\n";
    for $k (@$pending)
    {
#	print "processing key $k\n";
	@war = PermTransforms::IdToPerm($k);

	for ($i = 0 ; $i < $width ; ++$i)
	{
	    for ($j = $i+1 ; $j < $width ; ++$j)
	    {
		@tar = @war;
		RevOn(\@tar,$i,$j);
		$nid = PermTransforms::PermToId(\@tar);
		next if exists $tree{$nid};
		$tree{$nid} = [ $curdepth + 1,$k,$i,$j];
		push @$newpending,$nid;
		
#		print "   inserting new item ",join(",",@{$tree{$nid}}),"\n";

		$tsize = scalar keys %tree;
		print "$tsize -- $curdepth\n" if ($tsize % 10000) == 0;


	    }
	}
    }
    $pending = $newpending;
    ++$curdepth;
}

print "paths processed, tree size is: ",scalar keys %tree,"\n";
#for $k (sort {$a <=> $b} keys %tree)
#{
#    print $k,"(",join(",",PermTransforms::IdToPerm($k)),"): ",join(",",@{$tree{$k}}),"\n";
#}
#exit(0);

while(1)
{
    print "file to load: ";
    $fn = <STDIN>;
    $fn =~ s/\r?\n//;

    if (!open(FD,$fn))
    {
	print "can't open $fn\n";
	next;
    }

    $lc = 0;
    @sets = ();
    while(<FD>)
    {
	$_ =~ s/\r?\n//;
	next unless length($_) > 0;
	@lar = split(" ",$_);
	if ($lc % 2 == 0)
	{
	    $ci = [];
	    @{$ci->[0]} = @lar;
	}
	else
	{
	    @{$ci->[1]} = @lar;
	    push @sets,$ci;
	}
	++$lc;
    }
    close(FD);

    for $set (@sets)
    {
	# 1: determine what the mapping is between the
	# start and perm0, (so that the post-mapped start is id 0)
	# and apply the same mapping to end.
	for (my $i = 1 ; $i <= $width ; ++$i)
	{
	    $xlate{$set->[0]->[$i-1]} = $i;
	}
	@end = ();
	for (my $i = 0 ; $i < $width ; ++$i)
	{
	    push @end,$xlate{$set->[1]->[$i]};
	}

	print "end: ",join(",",@end),"\n";
	$endid = PermTransforms::PermToId(\@end);

	$curid = $endid;
	print join(",",@{$set->[0]})," -> ",join(",",@{$set->[1]}),"\n";
	print ">>>>>> ",$tree{$curid}->[0]," <<<<<\n";
	while(1)
	{
	    $info = $tree{$curid};
	    print " ",join(",",@{$info}),"\n";
	    last if $info->[0] == 0;
	    $curid = $info->[1];
	}
    }
}
