BEGIN { push @INC,"../common"; }

use TaxaTree;

sub UniqueName
{
    return "DUMMY" . $uid++;
}

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");

$taxa = <FD>;
$taxa =~ s/\r?\n$//;

@taxa = split(" ",$taxa);

my @leaves;
my @inners;
my %leavesbyname;

$root = new TaxaTree(UniqueName());
push @inners,$root;


for $t (@taxa)
{
    $n = new TaxaTree($t);
    $root->AddChild($n);
    $n->AddChild($root);

    push @leaves,$n;
    $leavesbyname{$t} = $n;
}

#print GetNewick(),"\n";

while(<FD>)
{
    $_ =~ s/\r?\n$//;
    my @splittaxa0 = ();
    my @splittaxa1 = ();

    for ($i = 0 ; $i < length($_) ; ++$i)
    {
	$c = substr($_,$i,1);
	if ($c eq "0") 
	{ 
	    push @splittaxa0,$taxa[$i];
	}
	else 
	{ 
	    push @splittaxa1,$taxa[$i];
	}
    }

    # operate on whichever one has fewer taxa
    Operate(scalar @splittaxa0 < scalar @splittaxa1 ? @splittaxa0 : @splittaxa1);
#    print GetNewick(),"\n";
}

close FD;

print GetNewick(),"\n";


sub Operate
{
    my (@split) = @_;

#    print "Operating on split ",join(",",@split),"\n";

    # 1) clear fullness from all nodes
    for $n (@leaves,@inners)
    {
	$n->ClearMarks();
    }

    # if I figured this correctly,
    # the very last node to mark should
    # return the node that we want to operate on.
    my $lastmarkednode;
    for my $s (@split)
    {
	$lastmarkednode = $leavesbyname{$s}->Mark();
    }

    # create a new node.
    my $nn = new TaxaTree(UniqueName());
    push @inners,$nn;

    $lastmarkednode->MoveMarkedToNew($nn);
    $lastmarkednode->AddChild($nn);
    $nn->AddChild($lastmarkednode);
}

sub GetNewick
{
    for $n (@leaves,@inners)
    {
	$n->ClearPrint();
    }
    return $root->NewickString();
}

