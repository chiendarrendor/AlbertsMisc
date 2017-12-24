BEGIN { push @INC,"../common"; }
use DNA;

# data structure
# key is string name of node
# value is index into node array of that node.
my %nodebystring;
# array of all node objects
my @nodearray;
# a node object has the following properties:
# STRING (string of node)
# INDEX (index of node)
# ADJACENTS [] array ref of nodearray indices to children.

sub GetOrCreateNode
{
    my ($str) = @_;
    if (exists $nodebystring{$str})
    {
	return $nodearray[$nodebystring{$str}];
    }
    my $newindex = scalar @nodearray;
    $nodebystring{$str} = $newindex;
    my $newnode = {STRING=>$str,INDEX=>$newindex,ADJACENTS=>[]};
    push @nodearray,$newnode;
    return $newnode;
}

sub Process
{
    my ($str) = @_;
    my $len = length($str)-1;

    my $ls = substr($str,0,$len);
    my $rs = substr($str,1,$len);

    my $lnode = GetOrCreateNode($ls);
    my $rnode = GetOrCreateNode($rs);
    push @{$lnode->{ADJACENTS}},$rnode->{INDEX};
}


die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");

while(<FD>)
{
    $_ =~ s/\r?\n$//;
    Process($_);
}
close FD;

my $numnodes = scalar @nodearray;

# we want to do a DFS search on this graph, looking for a 
# back-edge back to 0 when our depth is $numnodes.
# 
# nodes have STATE -- absent = have not seen node before
#                     1 = somewhere back in our current chain
#                     2 = closed.

sub MaxCycleFindDFS
{
    my ($procindex,$depth) = @_;

    my $node = $nodearray[$procindex];
    $node->{STATE} = 1;

    for my $childindex (@{$node->{ADJACENTS}})
    {
	if ($depth == $numnodes && $childindex == 0)
	{
	    return substr($node->{STRING},-1,1);
	}
	my $cnode = $nodearray[$childindex];
	next if exists $cnode->{STATE};

	# ok, so if we get here, cnode is good for a 
	# recurse.
	my $result = MaxCycleFindDFS($childindex,$depth+1);
	if ($result)
	{
	    return substr($node->{STRING},-1,1) . $result;
	}
    }
    $node->{STATE} = 2;
    return undef;
}

my $result = MaxCycleFindDFS(0,1);

print $result,"\n";
    



