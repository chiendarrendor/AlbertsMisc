package Evolutions;

sub new
{
	my ($class,$filename,$pokedex) = @_;
	my $this = {};
	bless $this,$class;
	open(FD,"<",$filename) || die("Can't open $filename for reading");
	
	
	my $lastpokemon = undef;
	my $curpokemon = undef;
	my $curevotext = undef;
	my $tempevotext = undef;
	while(<FD>)
	{
		s/\r?\n$//;
		next if /family/;
		
		my @line = split("\t");
		my $curi = 0;
		while($curi < @line)
		{
			if ($curi < @line - 1 and $line[$curi] eq $line[$curi+1])
			{
				# what we have here is a pokemon name
				$lastpokemon = $curpokemon;
				$curpokemon = $line[$curi];
				$curi += 2;
				if ($curevotext)
				{
					if ($pokedex->IsPokemon($lastpokemon) and $pokedex->IsPokemon($curpokemon))
					{
						my $frompok = $pokedex->GetPokemonInfo($lastpokemon);
						push @{$frompok->{EVOLUTIONS}},{ HOW=>$curevotext,TO=>$curpokemon };
					}
					$curevotext = undef;
					$tempevotext = undef;
				}
			}
			# 342 206 222 -- octal bytes for the -> character, used as marker for level stuff
			elsif($line[$curi] =~ /(.*) \342\206\222$/)
			{
				if ($curi == 0)
				{
					$curpokemon = $lastpokemon;
				}
				if ($tempevotext) { $curevotext = $tempevotext . "/" . $1 }
				else { $curevotext = $1; }
				$curi += 1;
			}
			elsif($line[$curi] =~ /^\s*$/) { $curi += 1; }
			else
			{
				if ($tempevotext) { $tempevotext = $tempevotext . "/" . $line[$curi]; }
				else { $tempevotext = $line[$curi]; }
				$curi += 1;
			}
		}
	}
}	




1;
