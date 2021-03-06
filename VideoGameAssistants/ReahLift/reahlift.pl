BEGIN { push @INC , "../Common/Perl" }

use Astar;

package ReahLift;

sub new
{
    my ($class) = @_;
    my $this = {};
    bless $this,$class;

    $this->{STRING} = "10100011010";
    $this->{PARENT} = undef;

    return $this;
}

sub CanonicalKey
{
    my ($this) = @_;
    return $this->{STRING};
}

sub other
{
    my ($char) = @_;
    if ($char eq '1')
    {
	return '0';
    }
    else
    {
	return '1';
    }
}

sub SwapClone
{
    my ($this,@swaps) = @_;
    my @ary;
    @ary = split(//,$this->{STRING});

    my $i;
    for ($i = 0 ; $i < @swaps ; ++$i)
    {
	$ary[$swaps[$i]] = other($ary[$swaps[$i]]);
    }

    my $newthis = {};
    bless $newthis,ref $this;
    $newthis->{PARENT} = $this->CanonicalKey();
    $newthis->{MOVE} = $swaps[0];
    $newthis->{STRING} = join("",@ary);
    return $newthis;
}

sub diff
{
    my ($s1,$s2) = @_;
    my @ary1;
    my @ary2;
    @ary1 = split(//,$s1);
    @ary2 = split(//,$s2);
    my $i;
    my $result;
    $result = "";
    for ($i = 0 ; $i < 11 ; ++$i)
    {
	if ($ary1[$i] ne $ary2[$i])
	{
	    $result .= ($i+1) . ",";
	}
    }
    return $result;
}

sub Successors
{
    my ($this) = @_;
    my @result;

    push @result, $this->SwapClone(0,10);
    push @result, $this->SwapClone(1,0,3);
    push @result, $this->SwapClone(2);
    push @result, $this->SwapClone(3,2,5);
    push @result, $this->SwapClone(4,7,5);
    push @result, $this->SwapClone(5,2,4);
    push @result, $this->SwapClone(6,8);

    push @result, $this->SwapClone(7,4,10);
    push @result, $this->SwapClone(8,1);
    push @result, $this->SwapClone(9,4,10);
    push @result, $this->SwapClone(10,6,0);

    return @result;
}

sub DisplayString
{
    my ($this) = @_;
    return $this->{STRING};
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

sub WinGrade
{
    my ($this) = @_;
    return 11;
}

sub Grade
{
    my ($this) = @_;
    my @ary;
    @ary = split(//,$this->{STRING});

    my $result = 0;
    
    my $i;
    for ($i = 0 ; $i < 11; ++$i)
    {
	if ($i == 0 ||
	    $i == 2 ||
	    $i == 3 || 
	    $i == 10)
	{
	    if ($ary[$i] eq '1')
	    {
		++$result;
	    }
	}
	else
	{
	    if ($ary[$i] eq '0')
	    {
		++$result;
	    }
	}
    }
    return $result;
}

package main;

Astar::Astar(new ReahLift(),1);
