package Character;

sub new
{
    my ($class) = @_;
    my $this = {TAXA=>{}};
    bless $this,$class;
    return $this;
}

sub AddTaxa
{
    my ($this,$taxa) = @_;
    $this->{TAXA}->{$taxa} = $taxa;
    $taxa->AddCharacter($this);
}

sub TaxaCount
{
    my ($this) = @_;
    return scalar keys %{$this->{TAXA}};
}

# called when this character has a pair of
# taxa.  Make a new TaxaTree Object, make the two taxa
# its children, and then inform the new node
# to inform all Characters to replace the two children with
# the new parent.
sub MakeTriple
{
    my ($this) = @_;
    my ($t1,$t2) = values %{$this->{TAXA}};
    # assume that, since our input is consistent, that
    # the two children have the same CHARACTERS as each other,
    my $nn = new TaxaTree("");
    $nn->InheritCharacters($t1);
    
    $nn->AddChild($t1);
    $nn->AddChild($t2);

    $nn->DispatchReplace();
}

sub Replace
{
    my ($this,$o1,$o2,$new) = @_;
    delete $this->{TAXA}->{$o1};
    delete $this->{TAXA}->{$o2};
    $this->{TAXA}->{$new} = $new;
}

sub ToString
{
    my ($this) = @_;
    my $result;

    my $first = 1;
    for my $t (values %{$this->{TAXA}})
    {
	$result .= " / " unless $first;
	$first = 0;
	$result .= $t->NewickString();
    }
    return $result;
}








1;
