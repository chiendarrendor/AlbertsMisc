
my $ctr = 0;

for (my $i = 1 ; $i <= 120 ; ++$i) {
    $octr = $ctr;
    for (my $j = 0 ; $j < length($i); ++$j) {
	if (substr($i,$j,1) eq '1') { ++$ctr; }
    }

    print "$i: ",($ctr-$octr),"\n";

}

print $ctr,"\n";
