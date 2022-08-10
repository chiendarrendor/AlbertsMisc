#! /c/Perl64/bin/perl.exe

use strict;


open(my $fd,"<","vanderveer.txt");

my %letters;

while(<$fd>) {
	chomp;
	next if /^\#/;
	for (my $i = 0 ; $i < length($_) ; ++$i) {
		my $char = substr($_,$i,1);
		
		if (!exists $letters{$char}) {
			$letters{$char} = [ [], [], [], [], [], [], [] ];
		}
		push @{$letters{$char}->[$i]},$_;
	}
}
	
for my $key (sort keys %letters) {
	my $wcount = 0;
	for (my $i = 0 ; $i < @{$letters{$key}} ; ++$i) {
		++$wcount if scalar @{$letters{$key}->[$i]};
	}
	next unless $wcount == scalar @{$letters{$key}};
	print $key,"\n";
	for (my $i = 0 ; $i < @{$letters{$key}} ; ++$i) {
		print($i,": ",join(" ",@{$letters{$key}->[$i]}),"\n");
	}
}
	