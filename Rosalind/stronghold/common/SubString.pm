# this class mimics a string, except that it
# references a constant StringWrapper string
package SubString;

sub new
{
    my ($class,$string,$first,$length) = @_;

    my $this = {};
    bless $this,$class;
    $this->{STRING} = $string;
    $this->{FIRST} = $first;
    $this->{LENGTH} = $length;
    return $this;
}

sub Length
{
    my ($this) = @_;
    return $this->{LENGTH};
}

sub GetCharAt
{
    my ($this,$index) = @_;
    return $this->{STRING}->GetCharAt($this->{FIRST}+$index);
}

sub SubSubString
{
    my ($this,$index,$length) = @_;
    return new SubString($this->{STRING},$this->{FIRST}+$index,$length);
}

sub SubStringToEnd
{
    my ($this,$index) = @_;
    return new SubString($this->{STRING},$this->{FIRST}+$index,
			 $this->{LENGTH} - $index);
}



sub ToString
{
    my ($this) = @_;
    my $result;
    for (my $i = 0 ; $i < $this->{LENGTH} ; ++$i)
    {
	$result .= $this->GetCharAt($i);
    }
    return $result;
}


1;
