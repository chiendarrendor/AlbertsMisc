package TaxaTree;

sub new
{
    my ($class,$name) = @_;
    my $this = {NAME=>$name,CHILDREN=>{}};
    bless $this,$class;

    return $this;
}

sub AddChild
{
    my ($this,$child) = @_;
    $this->{CHILDREN}->{$child->{NAME}} = $child;
}

sub ClearPrint
{
    my ($this) = @_;
    delete $this->{PRINTED};
}

sub NewickString()
{
    my ($this) = @_;
    my $result;

    return undef if $this->{PRINTED};
    $this->{PRINTED} = 1;

    return $this->{NAME} if scalar keys %{$this->{CHILDREN}} == 1;


    $result = "(";
    my $first = 1;

    for my $t (values %{$this->{CHILDREN}})
    {
	my $sub = $t->NewickString();
	next unless $sub;

	$result .= "," unless $first;
	$first = 0;
	$result .= $sub
    }
    $result .= ")";
#    $result .= $this->{NAME};
    return $result;
}

sub IsLeaf
{
    my ($this) = @_;
    return scalar keys %{$this->{CHILDREN}} == 1;
}

sub GetLeafChild
{
    my ($this) = @_;
    my @t = values %{$this->{CHILDREN}};
    return $t[0];
}

sub ClearMarks
{
    my ($this) = @_;
    delete $this->{MARKED};
    %{$this->{UNMARKED}} = %{$this->{CHILDREN}};
}

sub Mark
{
    my ($this,$from) = @_;

    if ($this->IsLeaf())
    {
#	print "Marking leaf $this->{NAME}, passing Mark along to ",$this->GetLeafChild()->{NAME},"\n";
	return $this->GetLeafChild()->Mark($this);
    }

#    print "In internal node $this->{NAME}, got mark from $from->{NAME}\n";
    
    # if we're here, we are an internal node.
    push @{$this->{MARKED}},$from->{NAME};
    delete $this->{UNMARKED}->{$from->{NAME}};
    
#    print "  num unmarked neighbors left: ",scalar keys %{$this->{UNMARKED}},"\n";
    return $this unless scalar keys %{$this->{UNMARKED}} == 1;

    # ok, so we have only one unmarked place for the marking to go
    # recurse there.
    my @t = values %{$this->{UNMARKED}};

#    print "  recursing to ",$t[0]->{NAME},"\n";

    return $t[0]->Mark($this);
}

sub MoveMarkedToNew
{
    my ($this,$other) = @_;

    for my $mname (@{$this->{MARKED}})
    {
	my $moving = $this->{CHILDREN}->{$mname};

	$moving->AddChild($other);
	$other->AddChild($moving);

	delete $moving->{CHILDREN}->{$this->{NAME}};
	delete $this->{CHILDREN}->{$mname};
    }
}





    




    





1;
