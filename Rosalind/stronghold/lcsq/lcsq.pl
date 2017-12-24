die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$str1 = <FD>;
$str1 =~ s/\r?\n$//;
$str2 = <FD>;
$str2 =~ s/\r?\n$//;
close FD;

sub NodeName
{
    my ($n) = @_;
    return $n->{IDX1} . "_" . $n->{IDX2};
}
    


for ($i = 0 ; $i < length($str1) ; ++$i)
{
    for ($j = 0 ; $j < length($str2) ; ++$j)
    {
	next unless substr($str1,$i,1) eq substr($str2,$j,1);
	$nodes{$i . "_" . $j} = { IDX1 => $i,
				  IDX2 => $j, 
				  NEXT => [],
				  PREV=>[],
				  CHAR=>substr($str1,$i,1) };
    }
}

for $n1 (values %nodes)
{
    # we're going to look for the minimal set 
    # of nearby subsequent nodes (if a node is 'past'
    # another node, meaning that you can get to by going to the
    # closer node first, having an edge to the further one
    # doesn't help us.

    my $maxx = length($str1); #(IDX1)
    my $maxy = length($str2); #(IDX2)

    for ($i = $n1->{IDX1}+1 ; $i < $maxx ; ++$i)
    {
	for ($j = $n1->{IDX2}+1 ; $j < $maxy ; ++$j)
	{
	    next unless exists $nodes{$i . "_" . $j};
	    $n2 = $nodes{$i . "_" . $j};

	    push @{$n1->{NEXT}},$n2;
	    push @{$n2->{PREV}},$n1;
	    ++$n2->{CURPREVCOUNT};

	    $maxy = $j;
	    last;
	}
    }
}

# make a TopoSort of this graph (has to be acyclic)
# will mutate CURPREVCOUNT
my @tsort;
my @noprev = grep { $_->{CURPREVCOUNT} == 0 } values %nodes;
while(@noprev)
{
    $curnode = shift @noprev;
    push @tsort,$curnode;

    for $child (@{$curnode->{NEXT}})
    {
	--$child->{CURPREVCOUNT};
	push @noprev,$child if $child->{CURPREVCOUNT} == 0;
    }
}


$deepestnode = undef;

for $n (@tsort)
{
    if (@{$n->{PREV}} == 0)
    {
	$n->{DEPTH} = 0 ;
    }
    else
    {
	$maxprev = 0;
	for $p (@{$n->{PREV}})
	{
	    $maxprev = $p->{DEPTH} if $p->{DEPTH} > $maxprev;
	}
	$n->{DEPTH} = $maxprev + 1;
    }

    if (!$deepestnode) { $deepestnode = $n; }
    elsif($n->{DEPTH} > $deepestnode->{DEPTH}) { $deepestnode = $n; }
}

# ok, so now we know how deep each node is, and 
# an exemplar deepest node.  go back up the node chain
# decreasing depth by one and build the substring.

$curnode = $deepestnode;

while(1)
{
    $result = $curnode->{CHAR} . $result;

    last unless @{$curnode->{PREV}};
    
    my $pnode;
    for (my $i = 0 ; $i < @{$curnode->{PREV}} ; ++$i)
    {
	$pnode = $curnode->{PREV}->[$i];
	last if $pnode->{DEPTH} == $curnode->{DEPTH} - 1;
    }

    $curnode = $pnode;
}

print "$result\n";



    




	
