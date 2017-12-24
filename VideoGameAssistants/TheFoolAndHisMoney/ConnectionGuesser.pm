package ConnectionGuesser;

# this class contains two pieces of information:
# a) the known next depths
# b) a possible known word for a given depth

sub new
{
    my ($class,$depths,$words) = @_;
    my $this = {};
    bless $this,$class;
    @{$this->{DEPTHS}} = @$depths;
    @{$this->{WORDS}} = @$words;
    return $this;
}

sub GetNextDepth
{
    my ($this,$sentence) = @_;
    my @sar = split(" ",$sentence);
    my $di = scalar @sar;
    return -1 if $di >= scalar @{$this->{DEPTHS}};
    return $this->{DEPTHS}->[$di];
}

sub GetKnownWord
{
    my ($this,$sentence) = @_;
    my @sar = split(" ",$sentence);
    my $di = scalar @sar - 1;
    return undef if $di >= scalar @{$this->{WORDS}};
    return undef if length($this->{WORDS}->[$di]) == 0;
    return $this->{WORDS}->[$di];
}

1;

    
