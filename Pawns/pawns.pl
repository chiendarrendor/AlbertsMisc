BEGIN { push @INC , "../Common/Perl" }

use Astar;

# grid:
#
# xxoooxx
# xxoooxx
# ooooooo
# ooo.ooo
# ooooooo
# xxoooxx  
# xxoooxx
# 
# object:
# try to end up with a single o
# by LRUD checker-jumping them into emtpy spaces

package Pawns;

sub new
{
    my ($class) = @_;
    my $this = {};
    bless $this,$class;

    $this->{STRING} = "xxoooxxxxoooxxoooooooooo.ooooooooooxxoooxxxxoooxx";
    $this->{PARENT} = undef;

    return $this;
}

sub CanonicalKey
{
    my ($this) = @_;
    return $this->{STRING};
}

sub at
{
    my ($this,$x,$y,$r) = @_;
    if ($r ne '')
    {
	substr($this->{STRING},$y*7+$x,1,$r);
    }
    else
    {
	return substr($this->{STRING},$y*7+$x,1);
    }
}

sub DisplayString
{
    my ($this) = @_;
    my $i;
    my $j;
    my $result = "";
    for ($i = 0 ; $i < 7 ; ++$i)
    {
	for ($j = 0 ; $j < 7 ; ++$j)
	{
	    $result .= $this->at($j,$i);
	}
	$result .= "\n";
    }
    return $result;
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
    return 31;
}

sub Grade
{
    my ($this) = @_;
    my $i,$j;
    my $result = 0;

    for ($i = 0 ; $i < 7 ; ++$i)
    {
	for ($j = 0 ; $j < 7 ; ++$j)
	{
	    if ($this->at($i,$j) eq '.')
	    {
		$result++;
	    }
	}
    }

    return $result;
}

sub isvalid
{
    my ($this,$cx,$cy,$sx,$sy) = @_;
    return 0 if ($cx < 0 || $cy < 0 || $sx < 0 || $sy < 0);
    return 0 if ($cx > 6 || $cy > 6 || $sx > 6 || $xy > 6);
    return 0 unless $this->at($cx,$cy) eq 'o';
    return 0 unless $this->at($sx,$sy) eq 'o';
    return 1;
}

sub CloneChange
{
    my ($this,$tx,$ty,$cx,$cy,$sx,$sy) = @_;
    my $result = new Pawns();
    $result->{STRING} = $this->{STRING};
    $result->{PARENT} = $this->CanonicalKey();
    $result->{MOVE} = "($sx,$sy) -> ($tx,$ty)";
    
    $result->at($tx,$ty,'o');
    $result->at($cx,$cy,'.');
    $result->at($sx,$sy,'.');
    return $result;
}


sub Successors
{
    my ($this) = @_;
    my @result;
    my $i,$j;

    # $i,$j is the target location.
    for ($i = 0 ; $i < 7 ; ++$i)
    {
	for ($j = 0 ; $j < 7 ; ++$j)
	{
	    # if it isn't empty, skip
	    next unless $this->at($i,$j) eq '.';

	    # four cases, U,D,L,R
	    # isvalid takes center and source
	    if ($this->isvalid($i-1,$j,$i-2,$j))
	    {
		# clonechange takes target,center,source
		push @result,$this->CloneChange($i,$j,$i-1,$j,$i-2,$j);
	    }
	    if ($this->isvalid($i+1,$j,$i+2,$j))
	    {
		# clonechange takes target,center,source
		push @result,$this->CloneChange($i,$j,$i+1,$j,$i+2,$j);
	    }
	    if ($this->isvalid($i,$j-1,$i,$j-2))
	    {
		# clonechange takes target,center,source
		push @result,$this->CloneChange($i,$j,$i,$j-1,$i,$j-2);
	    }
	    if ($this->isvalid($i,$j+1,$i,$j+2))
	    {
		# clonechange takes target,center,source
		push @result,$this->CloneChange($i,$j,$i,$j+1,$i,$j+2);
	    }
	}
    }
    return @result;
}	    

package main;







Astar::Astar(new Pawns(),1);
