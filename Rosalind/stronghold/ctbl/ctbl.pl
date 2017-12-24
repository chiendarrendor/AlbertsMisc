BEGIN { push @INC,"../common"; }
use Newick;

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");

$nk = <FD>;
$nk =~ s/\r?\n//;
close FD;

my $tree = new Newick($nk);

# 1) find all edges, uniquely, where both 
# nodes have more than one neighbor
#
my %seenedges;
sub SeenEdge
{
    my ($aname,$bname) = @_;
    my @ar = ($aname,$bname);
    @ar = sort @ar;
    return 1 if exists $seenedges{$ar[0],$ar[1]};
    $seenedges{$ar[0],$ar[1]} = 1;
    return 0;
}

sub IsLeaf
{
    my ($node) = @_;
    return scalar @{$node->{NEIGHBORS}} == 1;
}

sub PrintSplits
{
    my ($t) = @_;
    print "-----\n";
    for my $k (keys %{$t->{NODES}})
    {
	my $n = $t->{NODES}->{$k};
	print $n->{NAME},": ";
	if (!exists $n->{SPLITID}) { print "---"; }
	else { print $n->{SPLITID}; }
	print "\n";
    }
}




# given the tree, and two non-trivial nodes,
# partition the tree into two parts based on the split,
# and then, print the split ids of all leaf nodes
# in lexicographic order by name
sub PrintCharacterTable
{
    my ($tree,$node1,$node2) = @_;
    my %leafnames;
    for my $node (values %{$tree->{NODES}})
    {
	delete $node->{SPLITID};
	$leafnames{$node->{NAME}} = 1 if IsLeaf($node);
    }


    $node1->{SPLITID} = 0;
    $node2->{SPLITID} = 1;


    my @queue;
    push @queue,$node2;
    while(@queue)
    {
	my $qi = shift @queue;
	for my $cpair (@{$qi->{NEIGHBORS}})
	{
	    my $child = $cpair->[0];
	    next if exists $child->{SPLITID};
	    $child->{SPLITID} = 1;

	    push @queue,$child;
	}
    }

    for $k (sort keys %leafnames)
    {
	print $tree->{NODES}->{$k}->{SPLITID} == 1 ? 1 : 0;
    }
    print "\n";
}

	





for $node (values %{$tree->{NODES}})
{
    next if IsLeaf($node);
    for $opair (@{$node->{NEIGHBORS}})
    {
	$onode = $opair->[0];

	next if IsLeaf($onode);
	next if SeenEdge($node->{NAME},$onode->{NAME});
	# if we get here, we have a unique
	# non-trivial edge.
	PrintCharacterTable($tree,$node,$onode);
    }
}
