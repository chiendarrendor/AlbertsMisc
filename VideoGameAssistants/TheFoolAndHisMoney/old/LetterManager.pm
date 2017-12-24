package LetterManager;

sub new 
{
    my ($class,$lset) = @_;
    my $this = {};
    bless $this,$class;
    $this->Deserialize($lset);
    return $this;
}

sub Deserialize
{
    my ($this,$lset) = @_;
    my @lar = split("/",$lset);

    $this->SetParse($lar[0],"A");
    $this->SetParse($lar[1],"B");
}

sub SetParse
{
    my ($this,$setstring,$setid) = @_;
    my @dar = split("-",$setstring);

    $this->{$setid . "COUNT"} = $dar[0];
    @{$this->{$setid . "SET"}} = split("",$dar[1]);
}


sub clone
{
    my ($this) = @_;
    my $result = {};
    bless $result,ref $this;
    $result->{ACOUNT} = $this->{ACOUNT};
    $result->{BCOUNT} = $this->{BCOUNT};
    @{$result->{ASET}} = @{$this->{ASET}};
    @{$result->{BSET}} = @{$this->{BSET}};
    return $result;
}


sub Serialize
{
    my ($this) = @_;
    return $this->{ACOUNT} . '-' . join("",@{$this->{ASET}}) . '/' 
	. $this->{BCOUNT} . '-' . join("",@{$this->{BSET}});
}

sub GetUnused
{
    my ($this) = @_;
    my $result = [];
    for (my $i = 0 ; $i < @{$this->{ASET}} && $i < 5 ; ++$i)
    {
	push @$result, $this->{ASET}->[$i] . 'A';
    }
    for (my $i = 0 ; $i < @{$this->{BSET}} && $i < 5 ; ++$i)
    {
	push @$result, $this->{BSET}->[$i] . 'B';
    }
    return $result;
}

sub FullDepth
{
    my ($this) = @_;
    return scalar @{$this->{ASET}} + scalar @{$this->{BSET}};
}

sub AllUsed
{
    my ($this) = @_;
    return scalar @{$this->{ASET}} == 0 && scalar @{$this->{BSET}} == 0;
}

sub Remove
{
    my ($this,$letter) = @_;
    my @lar = split("",$letter);
    my $aref = ($lar[1] eq 'A') ? $this->{ASET} : $this->{BSET};
    for (my $i = 0 ; $i < @$aref ; ++$i)
    {
	next unless $aref->[$i] eq $lar[0];
	splice(@$aref,$i,1);
	last;
    }
}

# given that we already know that two 
# paths are a) the same length, and b) have used
# the same set of letters to produce the same words
# this will give us a string that uniquely identifies the 
# state of the letterset. (is the number of items in aset and bset that
# cannot yet be seen)
sub CanonicalKey
{
    my ($this) = @_;
    
    my $da = @{$this->{ASET}} - 5;
    my $db = @{$this->{BSET}} - 5;
    $da = 0 if $da < 0;
    $db = 0 if $db < 0;

    return $da . "." . $db;
}

1;
