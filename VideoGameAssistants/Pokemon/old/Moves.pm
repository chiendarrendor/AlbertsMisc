package Moves;

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
		# items are id, name, type, category, contest, PP, Power, Accuracy, Gen
		my $move = {
			ID => $line[0],
			NAME => $line[1],
			TYPE => $line[2],
			CATEGORY => $line[3],
			CONTEST => $line[4],
			PP => $line[5],
			POWER => $line[6],
			ACCURACY => $line[7],
			GENERATION => $line[8],
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