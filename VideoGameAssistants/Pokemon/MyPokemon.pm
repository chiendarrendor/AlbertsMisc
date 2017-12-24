package MyPokemon;
use strict;
use TypeType;
use PokeDex;
use Moves;
use Evolutions;
use Term::ANSIColor;

sub new
{
	my ($class,$filename) = @_;
	my $this = bless {},$class;

	open(FD,"<",$filename) || die("Can't open $filename for reading");
	my $fl = <FD>;
	$fl =~ s/\r?\n$//;

	$this->{TYPETYPE} = new TypeType($fl . ".tt");
	$this->{POKEDEX} = new PokeDex($fl . ".pd",$this->{TYPETYPE});
	$this->{MOVEDB} = new Moves($fl . ".mv",$this->{TYPETYPE});
	$this->{EVOLUTIONS} = new Evolutions($fl . ".evo",$this->{POKEDEX});

	$this->{POKEMON} = [];
	my $curpok = undef;
	while(<FD>)
	{
		s/\r?\n$//;
		s/^(\S+)\s*$/$1/;
		next if /^#/;
		if (!/^\t/)
		{
			$curpok = {};
			my ($category,$name)=/^([*-]?)(.*)$/;
			
			push @{$this->{POKEMON}},$curpok;
			$curpok->{NAME} = $name;
			die("No such pokemon as $_") unless $this->{POKEDEX}->IsPokemon($name);
			$curpok->{TYPES} = $this->{POKEDEX}->GetPokemonInfo($name)->{TYPES};
			$curpok->{EVOLUTIONS} = $this->{POKEDEX}->GetPokemonInfo($name)->{EVOLUTIONS};
			$curpok->{MOVES} = [];
			$curpok->{ISTEAM} = 1 if $category eq '*';
			$curpok->{ABSENT} = 1 if $category eq '-';
		}
		else
		{
			my ($movename) = /^\t(.*)$/;
			die("Move must come after a pokemon!") unless $curpok;
			die("No such pokemon move name as $movename") unless $this->{MOVEDB}->IsMove($movename);
			push @{$curpok->{MOVES}},$this->{MOVEDB}->GetMove($movename);
		}
	}

	close FD;
	return $this;
}

# make a string representing all attack types that are 
# special to this pokemon, and how special:
# x4 to attack    (white text on red)
# x2 to attack    (black text on yellow)
# x1 to attack (normal, ignore)
# x1/2 to attack  (black text on green)
# x1/4 to attack  (white text on blue)
# x0 to attack    (black text on white)
sub Defensive
{
	my ($typetype,$pokemon) = @_;
	my @defar;
	
	for my $attacktype ($typetype->GetTypes())
	{
		my $bonus = 1;
		for my $deftype (@{$pokemon->{TYPES}})
		{
			my $thisbonus = $typetype->GetAttackBonus($attacktype,$deftype);
			$bonus *= $thisbonus;
		}
		next if $bonus == 1;
		push @defar, { ATTNAME=>$attacktype,BONUS=>$bonus };
	}
	
	@defar = sort { $a->{BONUS} <=> $b->{BONUS} } @defar;
	my @far;
	my $result = "";
	for my $ent (@defar)
	{
		my $fent = "";
		$fent = color('white','on_red') if $ent->{BONUS} == 4;
		$fent = color('black','on_yellow') if $ent->{BONUS} == 2;
		$fent = color('black','on_green') if $ent->{BONUS} == 0.5;
		$fent = color('white','on_blue') if $ent->{BONUS} == 0.25;
		$fent = color('black','on_white') if $ent->{BONUS} == 0;
		$fent .= $ent->{ATTNAME};
		$fent .= color('reset');
		push @far,$fent;
	}
	return join(",",@far);
}

sub Offensive
{
	my ($typetype,$atttype) = @_;
	my @atar;
	for my $deftype ($typetype->GetTypes())
	{
		my $bonus = $typetype->GetAttackBonus($atttype,$deftype);
		next if $bonus == 1;
		push @atar, { DEFNAME => $deftype , BONUS => $bonus };
	}
	my @far;
	@atar = sort { $b->{BONUS} <=> $a->{BONUS} } @atar;
	for my $ent (@atar)
	{
		my $fent = "";
		$fent = color('white','on_red') if $ent->{BONUS} == 0.5;
		$fent = color('black','on_green') if $ent->{BONUS} == 2;
		$fent = color('black','on_white') if $ent->{BONUS} == 0;
		$fent .= $ent->{DEFNAME};
		$fent .= color('reset');
		push @far,$fent;		
	}
	return join(",",@far);
}

sub IsEvolvable
{
	my ($pokemon) = @_;
	
	for my $evo (@{$pokemon->{EVOLUTIONS}})
	{
		if ($evo->{HOW} ne "Trade") { return 1; }
	}
	return 0;
}



# showtype is:
#   ALL
#   ACTIVE
#   EVOLVE
sub Display
{
	my ($this,$showtype) = @_;
	
	for my $pokemon (@{$this->{POKEMON}})
	{
		next if $pokemon->{ABSENT};
		if ($showtype eq "ACTIVE" && !exists $pokemon->{ISTEAM}) { next; }
		if ($showtype eq "EVOLVE" && !IsEvolvable($pokemon)) { next; }

		print $pokemon->{NAME},": ",join(",",@{$pokemon->{TYPES}})," (",Defensive($this->{TYPETYPE},$pokemon),")\n";
		for my $evo (@{$pokemon->{EVOLUTIONS}})
		{
			print "\t";
			print $evo->{HOW},' -> ',$evo->{TO},"\n";
		}
		print "\n";
		
		
		for my $move (@{$pokemon->{MOVES}})
		{
			my $is_stab == 0;
			for my $type (@{$pokemon->{TYPES}}) { if ($type eq $move->{TYPE}) { $is_stab = 1; } }
		
		
			print "\t";
			print color('black','on_green') if $move->{CATEGORY} eq 'Special';
			print color('white','on_blue') if $move->{CATEGORY} eq 'Status';
			print $move->{NAME};
			print color('reset');
			print "(";
			print $move->{TYPE};
			
			unless ($move->{CATEGORY} eq 'Status')
			{
				print ",";
				print $move->{POWER};
				if ($is_stab)
				{
					print "x1.5=";
					print ($move->{POWER} * 3 / 2);
				}
			}
			
			print "): ";
			if ($move->{CATEGORY} eq 'Status')
			{
				print "\n";
			}
			else
			{
				print Offensive($this->{TYPETYPE},$move->{TYPE}),"\n";
			}
			print "\t\t--",$move->{DESC},"\n";
		}
		print "\n";
	}
}

sub ShowPokedex()
{
	my ($this) = @_;
	
	my @pnums = $this->{POKEDEX}->GetNumbers();

	my %ppresence;
	
	for my $pok (@{$this->{POKEMON}})
	{
		$ppresence{$pok->{NAME}} = "Owned";
		$ppresence{$pok->{NAME}} = "Previously Owned" if $pok->{ABSENT};
		
		unless($pok->{ABSENT})
		{
			my @worklist = ( $pok->{NAME} );
			while(@worklist)
			{
				my $curwork = shift @worklist;
				my $curpok = $this->{POKEDEX}->GetPokemonInfo($curwork);
						
				for my $evo (@{$curpok->{EVOLUTIONS}})
				{
					$ppresence{$evo->{TO}} = "Tradable: $evo->{HOW}" if $evo->{HOW} eq "Trade";
					$ppresence{$evo->{TO}} = "Evolvable: $evo->{HOW}" if !exists $ppresence{$evo->{TO}};
					push @worklist, $evo->{TO};
				}
			}
		}
	}
	
	
	my $pcount = 0;
	my $evocount = 0;
	my $tcount = 0;
	for (my $i = 0 ; $i < @pnums ; ++$i)
	{
		my $pnum = $pnums[$i];
		my $pname = $this->{POKEDEX}->GetNameOfNumber($pnum);
		printf("%s\t%20s",$pnum,$pname);
		if (exists $ppresence{$pname})
		{
			if ($ppresence{$pname} =~ /Owned/) { ++$pcount; }
			if ($ppresence{$pname} =~ /Evolvable/) { ++$evocount; }
			if ($ppresence{$pname} =~ /Tradable/) { ++ $tcount; }
			print "\t",$ppresence{$pname};
		}
		print "\n";
	}
	print "Pokemon indexed: $pcount\n";
	print "Evolvable: $evocount\n";
	print "Tradable: $tcount\n";
	print "Total: ", ($tcount + $evocount + $pcount), "\n";
}

1;