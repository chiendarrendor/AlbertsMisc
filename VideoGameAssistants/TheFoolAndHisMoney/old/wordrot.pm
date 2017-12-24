
package wordrot;

# state is array, value is index into corresponding letter string

sub CanonicalKey
{
    my ($this) = @_;
    my $result = "K";
    for (my $i = 0 ; $i < $this->{GAMEINFO}->GetLetterCount() ; ++$i)
    {
	$result .= $this->{STATE}->[$i];
    }
    return $result;
}

sub DisplayString
{
    my ($this) = @_;
    my $result;

    for (my $i = 0 ; $i < $this->{GAMEINFO}->GetLetterCount() ; ++ $i)
    {
	my $lidx = $this->{STATE}->[$i];
	$result .= substr($this->{GAMEINFO}->GetLetter($i),$lidx,1);
    }
    return $result,"\n";
}

sub Move
{
    my ($this) = @_;
    return $this->{MOVE};
}

sub Parent
{
    my ($this) = @_;
    return $this->{PARENT};
}

sub WinGrade()
{
    my ($this) = @_;
    return $this->{GAMEINFO}->GetLetterCount();
}

sub Grade()
{
    my ($this) = @_;
    my $result = 0;

    for (my $i = 0 ; $i < $this->{GAMEINFO}->GetLetterCount() ; ++$i)
    {
	my $lidx = $this->{STATE}->[$i];
	++$result if $lidx == $this->{GAMEINFO}->GetGoal($i);
    }
    return $result;
}

sub new
{
    my ($class,$gameinfo,$state,$move,$parent) = @_;
    my $this = {};
    $this->{GAMEINFO} = $gameinfo;
    bless $this,$class;


    if (!defined $state)
    {
	$this->{STATE} = [];
	for (my $i = 0 ; $i < $this->{GAMEINFO}->GetLetterCount() ; ++$i)
	{
	    $this->{STATE}->[$i] = $this->{GAMEINFO}->GetInitial($i);
	}
    }
    else
    {
	$this->{STATE} = [];
	for (my $i = 0 ; $i < @$state ; ++$i)
	{
	    $this->{STATE}->[$i] = $state->[$i];
	}
	$this->{KEY} = $key;
	$this->{MOVE} = $move;
	$this->{PARENT} = $parent;
    }
    return $this;
}

sub incrot
{
    my ($this,$x) = @_;
    return ($x+1) % $this->{GAMEINFO}->GetRotationWidth();
}

sub Successor
{
    my ($this,$actor) = @_;
    my $actref = $this->{GAMEINFO}->GetActor($actor);
    my @tempar = @{$this->{STATE}};
    for (my $i = 0 ; $i < @$actref ; ++$i)
    {
	$tempar[$actref->[$i]] = $this->incrot($tempar[$actref->[$i]]);
    }
    return new wordrot($this->{GAMEINFO},
		       \@tempar,$actor,$this->CanonicalKey());
}


sub Successors()
{
    my ($this) = @_;
    my @result;
    
    for (my $i = 0 ; $i < $this->{GAMEINFO}->GetNumActors() ; ++$i)
    {
	push @result,$this->Successor($i);
    }
    return @result;
}

1;
