
use Astar;


package Lights;

sub new($)
{
	my $this = bless {},$_[0];
	$this->{VAL} = 0;
	$this->{DEPTH} = 0;
	return $this;
}

sub CanonicalKey($)
{
	my ($this) = @_;
	return "K" . $this->{VAL};
}

sub DisplayString($)
{
	my ($this) = @_;
	return "-" . $this->{VAL} . "-";
}

sub Move($)
{
	my ($this) = @_;
	return $this->{MOVE};
}

sub Parent($)
{
	my ($this) = @_;
	return $this->{PARENT};
}

sub Depth($)
{
	my ($this) = @_;
	return $this->{DEPTH};
}

sub WinGrade()
{
	return 5000;
}

sub Grade($)
{
	my ($this) = @_;
	
	return $this->WinGrade() - abs($this->{VAL} - 3493);
}

sub Successors($)
{
	my ($this) = @_;
	my @result;
	
	# only two choices: +7 or x10
	my $plus7 = new Lights();
	$plus7->{VAL} = ($this->{VAL} + 7) % 10000;
	$plus7->{DEPTH} = $this->{DEPTH} + 1;
	$plus7->{MOVE} = "+7";
	$plus7->{PARENT} = $this->CanonicalKey();
	push @result,$plus7;
	
	my $times10 = new Lights();
	$times10->{VAL} = ($this->{VAL} * 10) % 10000;
	$times10->{DEPTH} = $this->{DEPTH} + 1;
	$times10->{MOVE} = "x10";
	$times10->{PARENT} = $this->CanonicalKey();
	push @result,$times10;	

	return @result;
}

package main;

Astar::Astar(new Lights(),1);

	
	



