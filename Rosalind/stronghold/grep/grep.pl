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

# breaks the string down into chunks of size $k+1
# and passes each chunk to Process
sub ProcessKmer
{
    my ($str,$k) = @_;
    my $klen = $k+1;
    my $len = length($str);

    for (my $i = 0 ; $i <= $len - $klen ; ++$i)
    {
	Process(substr($str,$i,$klen));
    }
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


die("bad command line") unless @ARGV == 1;
open(FD,$ARGV[0]) || die("can't open file");

my @raws;
while(<FD>)
{
    $_ =~ s/\r?\n$//;
    push @raws,$_;
}
close FD;
my $synk = length($raws[0])-1;



sub BuildDeBruijn
{
    my ($k) = @_;
    %nodebystring = ();
    @nodearray = ();
    for my $raw (@raws)
    {
	ProcessKmer($raw,$k);
    }
}


BuildDeBruijn($synk);

my $initialedgemarks = {};
for (my $i = 0 ; $i < @nodearray ; ++$i)
{
    my $n = $nodearray[$i];

    for (my $j = 0 ; $j < @{$n->{ADJACENTS}} ; ++$j)
    {
	$initialedgemarks->{$i."_".$j} = 1;
    }
#    print "node $i: ",$n->{STRING},"\n";
#    print "  ",join(",",@{$n->{ADJACENTS}}),"\n";

}

my %results;
my $rootnode = 0;

sub FindPaths
{
    my ($nodeid,$edgemarks,$prefix) = @_;

    if ($nodeid == $rootnode && scalar keys %$edgemarks == 0)
    {
#	push @results,$prefix;
	++$results{$prefix};
	return;
    }

    my $node = $nodearray[$nodeid];
    my $curstring = $prefix . substr($node->{STRING},0,1);
    
    for (my $i = 0 ; $i < @{$node->{ADJACENTS}} ; ++$i)
    {
	
	my $cem;
	%$cem = %$edgemarks;

	next unless exists $cem->{$nodeid . "_" . $i};
	delete $cem->{$nodeid . "_" . $i};

	my $nidx = $node->{ADJACENTS}->[$i];
	FindPaths($nidx,$cem,$curstring);
    }
}

FindPaths($rootnode,$initialedgemarks,"");

print join("\n", keys %results),"\n";

    
    




