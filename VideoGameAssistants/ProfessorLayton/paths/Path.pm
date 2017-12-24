package Path;

sub new
{
    my ($class,$start,$verts) = @_;
    my $this = {};
    bless $this,$class;
    $this->{VERTS} = $verts;
    $this->{PATH} = [$start];
    $this->{USED} = {};
    return $this;
}

sub Last
{
    my ($this) = @_;
    return $this->{PATH}->[-1];
}

sub Clone() {
    my ($this) = @_;
    my $result = {};
    bless $result,ref $this;
    $result->{VERTS} = $this->{VERTS};
    for (my $i = 0 ; $i < @{$this->{PATH}} ; ++$i) {
	$result->{PATH}->[$i] = $this->{PATH}->[$i];
    }
    foreach my $key (keys %{$this->{USED}}) {
	$result->{USED}->{$key} = $this->{USED}->{$key};
    }
    return $result;
}

sub EKey
{
    my ($left,$right) = @_;
    if ($left lt $right) { return $left . "_" . $right; }
    return $right . "_" . $left;
}

sub Extend
{
    my ($this) = @_;
    my @result;

    my $curp = $this->Last();
    for (my $i = 0 ; $i < @{$this->{VERTS}->{$curp}} ; ++$i) {
	my $np = $this->{VERTS}->{$curp}->[$i];
	next if exists $this->{USED}->{EKey($curp,$np)};
	my $newp = $this->Clone();
	push @{$newp->{PATH}},$np;
	$newp->{USED}->{EKey($curp,$np)} = 1;
	push @result,$newp;
    }
    return @result;
}

sub Overlaps
{
    my ($this,$other) = @_;
    if (@{$this->{PATH}} > @{$other->{PATH}}) { 
	return $other->Overlaps($this);
    }
    foreach my $key (keys %{$this->{USED}}) {
	if (exists $other->{USED}->{$key}) {
	    return 1;
	}
    }
    return 0;
}

1;
