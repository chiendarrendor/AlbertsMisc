package TaxaTree;

sub new
{
    my ($class,$name) = @_;
    my $this = {NAME=>$name,CHARACTERS=>[],CHILDREN=>[]};
    bless $this,$class;
    return $this;
}

sub InheritCharacters
{
    my ($this,$other) = @_;
    @{$this->{CHARACTERS}} = @{$other->{CHARACTERS}};
}

sub AddCharacter
{
    my ($this,$character) = @_;
    push @{$this->{CHARACTERS}},$character;
}

sub AddChild
{
    my ($this,$child) = @_;
    push @{$this->{CHILDREN}},$child;
}

# this should only be called if I have two children.
# tell each character to remove the two children and replace
# them with this.
sub DispatchReplace
{
    my ($this) = @_;
    my ($c1,$c2) = @{$this->{CHILDREN}};

    for my $ch (@{$this->{CHARACTERS}})
    {
	$ch->Replace($c1,$c2,$this);
    }
}

sub NewickString()
{
    my ($this) = @_;
    my $result;

    return $this->{NAME} if scalar @{$this->{CHILDREN}} == 0;

    $result = "(";
    my $first = 1;
    for my $t (@{$this->{CHILDREN}})
    {
	$result .= "," unless $first;
	$first = 0;
	$result .= $t->NewickString();
    }
    $result .= ")";
    return $result;
}

	





1;
