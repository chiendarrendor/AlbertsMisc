#! /c/Perl64/bin/perl.exe

my $base = "1234";
my %permutations;

sub permute {
	my ($partial,$tbd) = @_;
	if (length($tbd) == 0) { $permutations{$partial} = 1; return ; }
	for (my $i = 0 ; $i < length($tbd) ; ++$i ) {
		my $nexttbd = $tbd;
		my $nextchar = substr($tbd,$i,1);
		substr($nexttbd,$i,1,"");
		my $nextpartial = $partial . $nextchar;
		permute($nextpartial,$nexttbd);
	}
}



permute("","1234");
for my $key (keys %permutations) { print "K:",$key,"\n"; }
