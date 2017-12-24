package Moves;


sub TypeTransform
{
	my ($intype) = @_;
	
	$intype = ucfirst($intype);
	$intype = "Fight" if $intype eq "Fighting";
	$intype = "Electra" if $intype eq "Electric";
	return $intype;
}

sub CategoryTransform
{
	my ($incat) = @_;
	return "Physical" if $incat eq "physical";
	return "Special" if $incat eq "special";
	return "Status";
}


sub new
{
	my ($class,$filename,$tt) = @_;
	my $this = {};
	bless $this,$class;
	$this->{MOVES} = {};
	
	open(FD,"<",$filename) || die("Can't open $filename for reading");
	
	while(<FD>)
	{
		s/\r?\n$//;
		next if /^#/;
		my @line = split("\t");	
		# items are name, type, category, power, accuracy, secondary effect, power points, desc
		# http://pldh.net/dex/list/move-list
		my $move = {
			NAME => $line[0],
			TYPE => TypeTransform($line[1]),
			CATEGORY => CategoryTransform($line[2]),
			POWER => $line[3],
			ACCURACY => $line[4],
			SECONDARY => $line[5],
			PP => $line[6],
			DESC => $line[7]
		};
		die("unknown type: $move->{TYPE}") unless $tt->IsType($move->{TYPE});
		$this->{MOVES}->{$move->{NAME}} = $move;
	}
	return $this;
}

sub IsMove
{
	my ($this,$movename) = @_;
	return exists $this->{MOVES}->{$movename};
}

sub GetMove
{
	my ($this,$movename) = @_;
	return $this->{MOVES}->{$movename};
}

sub GetMoveNames
{
	my ($this) = @_;
	return keys %{$this->{MOVES}};
}

#print "\n";
#for my $movename ($moves->GetMoveNames())
#{
#	my $move = $moves->GetMove($movename);
#	printf("%15s  %s\n",$move->{NAME},$move->{TYPE});
#}







1;