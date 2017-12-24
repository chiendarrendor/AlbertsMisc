package StringWrapper;

sub new
{
    my ($class,$str) = @_;
    my $this = [];
    bless $this,$class;
    @$this = split("",$str);
    return $this;
}

sub Length
{
    my ($this) = @_;
    return scalar @$this;
}

sub GetCharAt
{
    my ($this,$index) = @_;
    return $this->[$index];
}

1;
