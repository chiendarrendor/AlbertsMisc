BEGIN { push @INC,"../common/Perl/"; }
use ShowDataStructure;

package FlipFlop;

sub new
{
    my ($class,$name,$offdest,$ondest) = @_;
    my $this = {};
    bless $this,$class;

    $this->{NAME} = $name;
    $this->{OFFDEST} = $offdest;
    $this->{ONDEST} = $ondest;
    $this->{STATUS} = "off";

    return $this;
}

sub Go
{
    my ($this,$val) = @_;

#    print "FF(",$this->{NAME},"): $val\n";

    if ($this->{STATUS} eq "off")
    {
	$this->{OFFDEST}->Go($val);
	$this->{STATUS} = "on";
    }
    else
    {
	$this->{ONDEST}->Go($val);
	$this->{STATUS} = "off";
    }
}

package Terminal;
sub new
{
    my ($class,$name) = @_;
    my $this = {};
    bless $this,$class;

    $this->{NAME} = $name;
    $this->{VALUES} = [];

    return $this;
}

sub Go
{
    my ($this,$val) = @_;
    push(@{$this->{VALUES}},$val);
#    print "Term(",$this->{NAME},"): $val\n";
}

sub Show
{
    my ($this) = @_;
    return join(",",$this->{NAME},@{$this->{VALUES}});
}

package Circuit;
# this class takes a string of the form
# <symbol>[>-]<symbol>...
# a '>' means the flip-flop signal ("on") is attached to the next flip flop
# whereas '-' means the non-flip-flop signal "off" is attached to the next flip flop
# the last symbol should not have an operator after it
sub new
{
    my ($class,$string) = @_;
    my ($this) = {};
    bless $this,$class;
    $this->{FLIPFLOPS} = [];
    $this->{TERMINALS} = [];
    $this->{STRING} = $string;
    $this->{ORIGSTRING} = $string;
    $this->{SYMCOUNT} = 0;

    die("string should not have terminal operator") if (defined $this->GetOperator());
    my $finalff = $this->GetSymbol();
    my $onterm = new Terminal("On " . $finalff);
    my $offterm = new Terminal("Off " . $finalff);
    unshift (@{$this->{TERMINALS}},$offterm);
    unshift (@{$this->{TERMINALS}},$onterm);
    unshift (@{$this->{FLIPFLOPS}},new FlipFlop($finalff,$offterm,$onterm));
    $this->{SYMCOUNT}++;

    while(1)
    {
	my $op = $this->GetOperator();
	last unless defined $op;
	my $ffname = $this->GetSymbol();
	my $nextff = $this->{FLIPFLOPS}->[0];
	$this->{SYMCOUNT}++;

	if ($op eq '-')
	{
	    $onterm = new Terminal("On " . $ffname);
	    unshift (@{$this->{TERMINALS}},$onterm);
	    unshift(@{$this->{FLIPFLOPS}},new FlipFlop($ffname,$nextff,$onterm));
	}
	else
	{
	    $offterm = new Terminal("Off " . $ffname);
	    unshift(@{$this->{TERMINALS}},$offterm);
	    unshift(@{$this->{FLIPFLOPS}},new FlipFlop($ffname,$offterm,$nextff));
	}
    }

    return $this;
}

sub Go
{
    my ($this) = @_;
    my $i;
   
    for ($i = 1 ; $i <= 2**$this->{SYMCOUNT} ; ++$i)
    {
	$this->{FLIPFLOPS}->[0]->Go($i);
    }
}

sub Show
{
    my ($this) = @_;
    my $i;

    print $this->{ORIGSTRING},":\n";
    
    for ($i = 0 ; $i < @{$this->{TERMINALS}} ; ++$i)
    {
	print $this->{TERMINALS}->[$i]->Show(),"\n";
    }
}

sub GetOperator
{
    my ($this) = @_;

    return undef if (length($this->{STRING}) == 0);
    return undef unless (substr($this->{STRING},-1) eq "-" || substr($this->{STRING},-1) eq ">");
    my $result = substr($this->{STRING},-1);
    substr($this->{STRING},-1) = "";
    return $result;
}

sub GetSymbol
{
    my ($this) = @_;
    return undef if (length($this->{STRING}) == 0);
    return undef if (substr($this->{STRING},-1) eq "-" || substr($this->{STRING},-1) eq ">");
    my $i;
    for ($i = length($this->{STRING}) - 1 ; $i >= 0 ; --$i)
    {
	last if (substr($this->{STRING},$i,1) eq "-" || substr($this->{STRING},$i,1) eq ">");
    }
    $i++;
    my $result = substr($this->{STRING},$i);
    substr($this->{STRING},$i) = "";
    return $result;
}
 


package main;

sub doIt
{
    my ($str) = @_;
    my $c = new Circuit($str);
    $c->Go();
    $c->Show();
}

doIt("A-B");
doIt("A>B");
doIt("A-B-C");
doIt("A-B>C");
doIt("A>B-C");
doIt("A>B>C");
