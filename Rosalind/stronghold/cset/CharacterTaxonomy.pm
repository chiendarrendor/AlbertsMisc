package CharacterTaxonomy;
use TaxaTree;


# initialtaxa is either a scalar integer (taxa are 0 - n-1)
# or a ref to an array (in which case the taxa are as listed)
sub new
{
    my ($class,$initialtaxa) = @_;
    my $this = {};
    bless $this,$class;
    $this->{LEAVES} = [];
    $this->{INNERS} = [];
    $this->{LEAVESBYNAME} = {};
    $this->{TAXANAMES} = [];
    $this->{UID} = 0;
    $this->{ROOT} = new TaxaTree($this->UniqueName());
    push @{$this->{INNERS}},$this->{ROOT};

    if (ref $initialtaxa)
    {
	@{$this->{TAXANAMES}} = @$initialtaxa;
    }
    else
    {
	for (my $i = 0 ; $i < $initialtaxa ; ++$i) 
	{
	    push @{$this->{TAXANAMES}},$i;
	}
    }

    for (my $i = 0 ; $i < @{$this->{TAXANAMES}} ; ++$i)
    {
	my $n = new TaxaTree($this->{TAXANAMES}->[$i]);
	$this->{ROOT}->AddChild($n);
	$n->AddChild($this->{ROOT});

	push @{$this->{LEAVES}},$n;
	$this->{LEAVESBYNAME}->{$n->{NAME}} = $n;
    }

#    print "Initial tree: ",$this->GetNewick(),"\n";

    return $this;
}

sub ProcessCharacter
{
    my ($this,$character) = @_;
    my @splittaxa0 = ();
    my @splittaxa1 = ();

    if (length($character) != @{$this->{TAXANAMES}})
    {
	return 0;
    }
    for (my $i = 0 ; $i < length($character) ; ++$i)
    {
	my $c = substr($character,$i,1);
	if ($c eq "0") { push @splittaxa0,$this->{TAXANAMES}->[$i]; }
	else           { push @splittaxa1,$this->{TAXANAMES}->[$i]; }
    }	

    my @optaxa = scalar @splittaxa0 < scalar @splittaxa1 ? @splittaxa0 : @splittaxa1;

    for my $n (@{$this->{LEAVES}},@{$this->{INNERS}}) { $n->ClearMarks(); }
    my $lastmarkednode;
    for my $sname (@optaxa)
    {
	$lastmarkednode = $this->{LEAVESBYNAME}->{$sname}->Mark();
    }

    if (@optaxa > @{$lastmarkednode->{MARKEDTAXA}})
    {
	return 0;
    }

    my $nn = new TaxaTree($this->UniqueName());
    push @{$this->{INNERS}},$nn;

    $lastmarkednode->MoveMarkedToNew($nn);
    $lastmarkednode->AddChild($nn);
    $nn->AddChild($lastmarkednode);

#    print "Character Process: ",$character,"\n";
#    print "After Character Process: ",$this->GetNewick(),"\n";

    return 1;
}




sub UniqueName
{
    my ($this) = @_;
    return "DUMMY" . $this->{UID}++;
}

sub GetNewick
{
    my ($this) = @_;
    for my $n (@{$this->{LEAVES}},@{$this->{INNERS}})
    {
	$n->ClearPrint();
    }
    return $this->{ROOT}->NewickString();
}

1;
