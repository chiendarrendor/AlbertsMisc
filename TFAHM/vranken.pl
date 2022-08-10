#! /c/Perl64/bin/perl.exe

my %vowels;
open(my $fd,"<","vranken.txt");
while(<$fd>) {
	chomp;
	my $copy = $_;
	$copy =~ tr/aeiou//dc;
	my $sort = join("",sort split(//,$copy));
	
	$vowels{$sort} = [] unless exists $vowels{$sort};
	push @{$vowels{$sort}},$_;
}

for my $vowel (keys %vowels) {
	print $vowel,": ",join(" ",@{$vowels{$vowel}}),"\n";
}

