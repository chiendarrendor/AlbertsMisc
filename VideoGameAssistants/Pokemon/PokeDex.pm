package PokeDex;

sub new
{
	my ($class,$filename,$typetype) = @_;
	my $this = {};
	bless $this,$class;
	$this->{POKEMON} = {};
	$this->{BYNUMBER} = {};
	
	open(FD,"<",$filename) || die("Can't open $filename for reading");
	
	while(<FD>)
	{
		s/\r?\n$//;
		my @line = split("\t");
		# pokedex should be rows of:
		# <number> <number> <name> <name> <type> [<second type>]
		
		my $types = [ $line[4] ];
		if (@line == 6) { push @$types,$line[5]; }
		
		my $pokemon = {
			NUMBER => $line[1],
			NAME => $line[3],
			TYPES => $types,
			EVOLUTIONS => [],
		};
		
		for my $type (@{$pokemon->{TYPES}})
		{
			die("$type is not a valid type for $pokemon->{NAME}") unless $typetype->IsType($type);
		}
		
		$this->{POKEMON}->{$pokemon->{NAME}} = $pokemon;
		$this->{BYNUMBER}->{$pokemon->{NUMBER}} = $pokemon->{NAME};
	}
	close(FD);
	return $this;
}

sub GetNameOfNumber
{
	my ($this,$number) = @_;
	return $this->{BYNUMBER}->{$number};
}

sub GetNumbers
{
	my ($this) = @_;
	return sort keys %{$this->{BYNUMBER}};
}


sub IsPokemon
{
	my ($this,$name) = @_;
	return exists $this->{POKEMON}->{$name};
}

sub GetPokemonInfo
{
	my ($this,$name) = @_;
	return $this->{POKEMON}->{$name};
}

#for (my $i = 1 ; $i <= 151 ; ++$i)
#{
#	my $name = $pd->GetNameOfNumber($i);
#	my $info = $pd->GetPokemonInfo($name);
#
#	printf("%03d: %15s ",$i,$name);
#	print $info->{TYPES}->[0];
#	if (scalar @{$info->{TYPES}} > 1) { print "\t",$info->{TYPES}->[1]; }
#	print "\n";
#}


1;
