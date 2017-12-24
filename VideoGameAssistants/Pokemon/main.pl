#!/bin/perl
use strict;
use MyPokemon;

my $fname = "mypokemon.txt";
my $showtype = "ACTIVE";

my $showall = 0;
my $showdex = 0;
for my $arg (@ARGV)
{
	if ($arg eq '-all') { $showtype = "ALL"; }
	elsif ($arg eq '-evolve') { $showtype = "EVOLVE"; }
	elsif ($arg eq '-pokedex') { $showdex = 1; }
	else { $fname = $arg; };
}

my $mypokemon = new MyPokemon($fname);

if ($showdex)
{
	$mypokemon->ShowPokedex();
}
else
{
	$mypokemon->Display($showtype);
}
