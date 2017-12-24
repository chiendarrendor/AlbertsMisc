package Newick;
use NewickNode;

sub new
{
    my ($class,$str) = @_;
    my $this = {};
    bless $this,$class;
    $this->{ROOT} = $this->Parse($str);
    return $this;
}

sub GetDummyName
{
    my ($this) = @_;
    return "NEWICK_DUMMY_" . $this->{UCTR}++;
}

sub Parse
{
    my ($this,$str) = @_;
    # case 0: a Newick tree must be semicolon-terminated.
    die("Bad Newick format '$str'") unless index($str,';') == length($str)-1;

    my $np = $this->ParseNode(substr($str,0,length($str)-1));

    return $np->[0];
}

# the string passed in, if valid, will be of the form
# [ '(' NodeList ')' ] [ name ] [ ':' number ]

sub ParseNode
{
    my ($this,$str) = @_;
    die("can't parse '$str'") unless $str =~ /^(\(.*\))?([A-Za-z][A-Za-z0-9_]*)?(:[0-9\-e+-.]+)?$/;
    
    my ($nodelist,$name,$number) = ($1,$2,$3);

    $name = $this->GetDummyName() unless length($name);

    if (length($number))
    {
	$number = substr($number,1);
    }
    else
    {
	$number = 1;
    }

    die("duplicate node name") if exists $this->{NODES}->{$name};

    my $result = new NewickNode($name);
    $this->{NODES}->{$name} = $result;
    
    if(length($nodelist) > 0)
    {
	$this->ParseNodeList($result,substr($nodelist,1,length($nodelist)-2));
    }
    return [$result,$number];
}

# this function takes its input string, breaking it up by commas that are
# not between '(' and ')', and passing each string to ParseNode
sub ParseNodeList
{
    my ($this,$parent,$str) = @_;
    my $parencount = 0;
    my $lastcomma = -1;
    my @result;


	for my $child (@children)
	{
	    $result->AddNeighbor($child);
	    $child->AddNeighbor($result);
	}

    for (my $i = 0 ; $i < length($str) ; ++$i)
    {
	my $c = substr($str,$i,1);
	if ($c eq '(') { ++$parencount; next; }
	if ($c eq ')') { --$parencount; next; }
	if ($c eq ',' && $parencount != 0) { next; }
	if ($c ne ',') { next; }

	my $rp = $this->ParseNode(substr($str,$lastcomma+1,$i-$lastcomma-1));
	$parent->AddNeighbor($rp->[0],$rp->[1]);
	$rp->[0]->AddNeighbor($parent,$rp->[1]);

	$lastcomma = $i;
    }

    my $rp = $this->ParseNode(substr($str,$lastcomma+1));
    $parent->AddNeighbor($rp->[0],$rp->[1]);
    $rp->[0]->AddNeighbor($parent,$rp->[1]);
}

sub CalculateDistance
{
    my ($this,$from,$to) = @_;
    for my $node (keys %{$this->{NODES}})
    {
	delete $node->{DISTANCE};
    }

    die("no such node $from") unless exists $this->{NODES}->{$from};
    die("no such node $to") unless exists $this->{NODES}->{$to};

    $this->{NODES}->{$from}->{DISTANCE} = 0;
    my @queue;
    push @queue,$this->{NODES}->{$from};

    while(@queue)
    {
	my $node = shift @queue;
	return $node->{DISTANCE} if $node->{NAME} eq $to;
	
	for my $child (@{$node->{NEIGHBORS}})
	{
	    $cnode = $child->[0];
	    $distance = $child->[1];

	    next if exists $cnode->{DISTANCE};
	    $cnode->{DISTANCE} = $node->{DISTANCE}+$distance;
	    push @queue,$cnode;
	}
    }
    return -1;
}

1;


