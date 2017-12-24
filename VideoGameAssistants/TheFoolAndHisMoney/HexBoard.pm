package HexBoard;
use HexWord;

sub new
{
    my ($class) = @_;
    my $this = {};
    bless $this,$class;
    return $this;
}

sub UsedWordCount
{
    my ($this) = @_;
    return scalar @{$this->{USEDWORDS}};
}

sub UnusedWordCount
{
    my ($this) = @_;
    return scalar @{$this->{UNUSEDWORDS}};
}

sub NewWord
{
    my ($this,$word,@coords) = @_;
    push @{$this->{UNUSEDWORDS}},new HexWord($word,@coords);
}

sub Clone
{
    my ($this) = @_;
    my $result = new HexBoard();
    for (my $i = 0 ; $i < @{$this->{USEDWORDS}} ; ++$i)
    {
	push @{$result->{USEDWORDS}},$this->{USEDWORDS}->[$i]->Clone();
    }
    for (my $i = 0 ; $i < @{$this->{UNUSEDWORDS}} ; ++$i)
    {
	push @{$result->{UNUSEDWORDS}},$this->{UNUSEDWORDS}->[$i]->Clone();
    }
    return $result;
}


sub UseWordByIndex
{
    my ($this,$index) = @_;
    my $unw = $this->{UNUSEDWORDS}->[$index];

    push @{$this->{USEDWORDS}},$unw;

    my $newUNW = [];
    for (my $i = 0 ; $i < $this->UnusedWordCount() ; ++$i)
    {
	my $tw = $this->{UNUSEDWORDS}->[$i];
	next if $tw->Overlaps($unw);
	push @$newUNW,$tw;
    }
    $this->{UNUSEDWORDS} = $newUNW;
}

sub PrintBoard
{
    my ($this) = @_;
    print "-----unused-----\n";
    foreach my $word (@{$this->{UNUSEDWORDS}}) { $word->Print(); }
    print "------used-----\n";
    foreach my $word (@{$this->{USEDWORDS}}) { $word->Print(); }
}








1;
