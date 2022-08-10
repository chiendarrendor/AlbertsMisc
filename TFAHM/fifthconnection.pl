#! /c/Perl64/bin/perl.exe

use strict;


sub setify($) {
	my ($word) = @_;
	my $result = {};
	for (my $i = 0 ; $i < length($word) ; ++$i) { ++$result->{substr($word,$i,1) }; }
	return $result;
}

sub isinset($$) {
	my ($dict,$word) = @_;
	for my $letter (keys %$word) {
		return 0 unless exists $dict->{$letter};
		return 0 unless $dict->{$letter} >= $word->{$letter};
	}
	return 1;
}

sub downset($$) {
	my ($dict,$word) = @_;
	for my $letter (keys %$word) {
		$dict->{$letter} -= $word->{$letter};
	}
}

sub upset($$) {
	my ($dict,$word) = @_;
	for my $letter (keys %$word) {
		$dict->{$letter} += $word->{$letter};
	}
}





my $rawletters = "WTLNTTAAHVEEERRSAMS";
my %letterset;
for (my $i = 0 ; $i < length($rawletters) ; ++$i) { ++$letterset{substr($rawletters,$i,1)}; }

open(my $fd,"<","collinswords2019.txt");

my %sixletters;
my %sevenletters;

while(<$fd>) {
	chomp;
	if (length == 6) {
		my $sixset = setify($_);
		next unless isinset(\%letterset,$sixset);
		$sixletters{$_} = 1;
	} elsif (length == 7) {
		my $sevenset = setify($_);
		next unless isinset(\%letterset,$sevenset);
		$sevenletters{$_} = 1;
	}
}

print "#six: ",scalar keys %sixletters,"\n";
print "Has wealth\n" if exists $sixletters{"WEALTH"};
print "Has master\n" if exists $sixletters{"MASTER"};
print "#seven: ",scalar keys %sevenletters,"\n";
print "Has servant\n" if exists $sevenletters{"SERVANT"};


for my $word1 (keys %sevenletters) {
	my $word1set = setify($word1);
	next unless isinset(\%letterset,$word1set);
	downset(\%letterset,$word1set);
	
	for my $word2 (keys %sixletters) {
		next if $word1 eq $word2;
		my $word2set = setify($word2);
		next unless isinset(\%letterset,$word2set);
		downset(\%letterset,$word2set);
		
		for my $word3 (keys %sixletters) {
			my $word3set = setify($word3);
			next unless isinset(\%letterset,$word3set);
			
			print "$word3 $word2 $word1\n";
		}
		upset(\%letterset,$word2set);
	}
	upset(\%letterset,$word1set);
}


