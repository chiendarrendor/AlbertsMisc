package ConnectionCell;
# string format for 'new':
# A[(B)][N]
# where A is the visible letter
# B is what prints when the letter is pressed
# N is the max repeat count for that letter
# cur repeat count will start at 0
# B, if not present, will be A
# N, if not present, will be 1

sub new
{
    my ($class,$istring) = @_;
    my $this = {};
    bless $this,$class;

    my ($name,$text,$count) = $istring =~ /^([a-z])(\([a-z]+\))?(\d+)?$/;
    $this->{LETTER} = $name;
    $this->{TEXT} = $text ? substr($text,1,length($text)-2) : $this->{LETTER};
    $this->{MAXCOUNT} = $count ? $count : 1;
    return $this;
}

sub clone
{
    my ($this) = @_;
    my $result = {};
    bless $result,ref $this;
    $result->{LETTER} = $this->{LETTER};
    $result->{TEXT} = $this->{TEXT};
    $result->{MAXCOUNT} = $this->{MAXCOUNT};
    $result->{CURCOUNT} = $this->{CURCOUNT};
    return $result;
}

sub IsFull
{
    my ($this) = @_;
    return $this->{MAXCOUNT} == $this->{CURCOUNT};
}


sub show
{
    my ($this) = @_;
    print $this->{LETTER};
}



1;

