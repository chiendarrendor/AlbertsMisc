package TypeType;
use strict;
use Term::ANSIColor;

sub new 
{
	my ($class,$filename) = @_;
	my $this = {};
	bless $this,$class;
	
	open(FD,"<",$filename) || die("Can't open $filename for reading");
	my $fl = <FD>;
	$fl =~ s/\r?\n$//;
	my @first = split("\t",$fl);
	shift @first;
	$this->{TYPES} = \@first;
	for (my $i = 0 ; $i < @first ; ++$i) 
	{
		$this->{TYPEINDEX}->{$first[$i]} = $i;
	}
	
	my $curtype = 0;
	while(<FD>)
	{
		s/\r?\n$//;
		my @lar = split("\t");
		my $ltype = shift @lar;
		die("bad file format: rows must be in the same order as columns: ($ltype) vs ($this->{TYPES}->[$curtype])") 
			unless $ltype eq $this->{TYPES}->[$curtype];
		
		for (my $i = 0 ; $i < @lar ; ++$i)
		{
			$this->{ATTBONUS}->{$ltype,$this->{TYPES}->[$i]} = $lar[$i] if length($lar[$i]) > 0;
		}

		++$curtype;
	}	
		
	close FD;
	return $this;
}

sub GetTypes
{
	my ($this) = @_;
	return @{$this->{TYPES}};
}

sub IsType
{
	my ($this,$type) = @_;
	return exists $this->{TYPEINDEX}->{$type};
}

sub GetAttackBonus
{
	my ($this,$attacker,$defender) = @_;
	die("Unknown types $attacker,$defender") unless $this->IsType($attacker) and $this->IsType($defender);
	return $this->{ATTBONUS}->{$attacker,$defender} if exists $this->{ATTBONUS}->{$attacker,$defender};
	return 1;
}

sub Display
{
	my ($this) = @_;
	my @tar = $this->GetTypes();
	for my $type (@tar)
	{
		print "\t$type";
	}
	print "\n";

	for my $att (@tar)
	{
		print color('reset');
		print $att;
		for my $def (@tar)
		{
			my $ab = $this->GetAttackBonus($att,$def);
			if ($ab == 1) { print color('black','on_white'); }
			elsif ($ab == 0) { print color('white','on_black'); }
			elsif ($ab == 2) { print color('white','on_green'); }
			elsif ($ab == 0.5) { print color('white','on_red'); }
			else                 { print color('black','on_yellow'); }
			print "\t$ab";
		}
		print color('reset');

		print "\n";
	}
	print "\n";
}	


1;
