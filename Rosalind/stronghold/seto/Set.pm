package Set;

sub new
{
    my ($class,$str) = @_;
    my $this = {};
    bless $this,$class;
    $str =~ y/{} //d;
    map { $this->{$_} = 'x'; } split(",",$str);
    return $this;
}

sub Union
{
    my ($this,$other) = @_;
    my $result = {};
    bless $result,ref $this;
    for my $k (keys %$this) { $result->{$k} = 'x'; }
    for my $k (keys %$other) { $result->{$k} = 'x'; }
    return $result;
}

sub Intersect
{
    my ($this,$other) = @_;
    my $result = {};
    bless $result,ref $this;
    for my $k (keys %$this)
    {
	$result->{$k} = 'x' if exists $other->{$k};
    }
    return $result;
}

sub Minus
{
    my ($this,$other) = @_;
    my $result = {};
    bless $result,ref $this;
    for my $k (keys %$this)
    {
	$result->{$k} = 'x' unless exists $other->{$k};
    }
    return $result;
}

sub ToString
{
    my ($this) = @_;
    my $result = '{' . join(", ",sort {$a<=>$b} keys %$this) . '}';
    return $result;
}

    




1;

