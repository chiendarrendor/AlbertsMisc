package Nullable;

sub new
{
    my ($class) = @_;
    my $this = {};
    bless $this,$class;

    $this->{ISNULL} = 1;
    return $this;
}

sub Set
{
    my ($this,$val) = @_;
    $this->{VALUE} = $val;
    $this->{ISNULL} = undef;
}

sub Get
{
    my ($this) = @_;
    die("Get on Null Nullable!\n") if ($this->{ISNULL});

    return $this->{VALUE};
}

sub Append
{
    my ($this,$val) = @_;
    $this->{VALUE} .= $val;
    $this->{ISNULL} = undef;
}


sub IsNull
{
    my ($this) = @_;
    return $this->{ISNULL};
}

sub SetNull
{
    my ($this) = @_;
    $this->{ISNULL} = 1;
}


1;
