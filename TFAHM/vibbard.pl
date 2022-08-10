#! /c/Perl64/bin/perl.exe

open(my $fd,"<","vibbard.txt");


my %subs;

while(<$fd>) {
	chomp;
	for (my $i = 0 ; $i < 5 ; ++$i) {
		my $substr = substr($_,$i,3);
		if (!exists($subs{$substr})) {
			$subs{$substr} = [];
		}
		push(@{$subs{$substr}},$_);
	}
}

for my $key (sort keys %subs) {
	my $ref = $subs{$key};
	next unless scalar @{$ref} > 2;
	print $key,":";
	for my $ent (@$ref) {
		print " ",$ent;
	}
	print "\n";
}

