package codon;


my %codons = 
(
 UUU=>F, CUU=>L, AUU=>I, GUU=>V,
 UUC=>F, CUC=>L, AUC=>I, GUC=>V,
 UUA=>L, CUA=>L, AUA=>I, GUA=>V,
 UUG=>L, CUG=>L, AUG=>M, GUG=>V,
 UCU=>S, CCU=>P, ACU=>T, GCU=>A,
 UCC=>S, CCC=>P, ACC=>T, GCC=>A,
 UCA=>S, CCA=>P, ACA=>T, GCA=>A,
 UCG=>S, CCG=>P, ACG=>T, GCG=>A,
 UAU=>Y, CAU=>H, AAU=>N, GAU=>D,
 UAC=>Y, CAC=>H, AAC=>N, GAC=>D,
         CAA=>Q, AAA=>K, GAA=>E,
         CAG=>Q, AAG=>K, GAG=>E,
 UGU=>C, CGU=>R, AGU=>S, GGU=>G,
 UGC=>C, CGC=>R, AGC=>S, GGC=>G,
         CGA=>R, AGA=>R, GGA=>G,
 UGG=>W, CGG=>R, AGG=>R, GGG=>G
);

my %stopcodons =
(
 UAA=>1,
 UGA=>1,
 UAG=>1
);

# returns either
# [ index of 'U' in first AUG,protein string ] or 
# undef

sub Translate
{
    my ($rna,$begin) = @_;
    my $result;
    my $idx = 0;
    my $stopped = 0;

#    print " "x$begin,"^\n";

    my $Aindex = index($rna,"AUG",$begin);

    return [-1,undef] if $Aindex == -1;

#    print " "x$Aindex,"!\n";

#    print " "x$Aindex;
    for ($idx = $Aindex ; $idx < length($rna) ; $idx += 3)
    {
	my $cod = substr($rna,$idx,3);
	
	if (exists $codons{$cod}) 
	{ 
	    $result .= $codons{$cod}; 
#	    print $codons{$cod}, "--";
	}
	elsif (exists $stopcodons{$cod}) 
	{ 
	    $stopped = 1; 
#	    print "***";
	    last; 
	}
	else { $result .= '?'; }
    }

#    print "\n";
    $result = undef unless $stopped;
    my $next = $Aindex + 3;
    $next = -1 if $next >= length($rna);
    return [$next,$result];
}

sub ProteinCounts
{
    my $result = {};
    for my $codon (keys %codons)
    {
	++$result->{$codons{$codon}};
    }
    return $result;
}

sub StopCount
{
    return scalar keys %stopcodons;
}

my %pweight = 
(
 A=>71.03711,
 C=>103.00919,
 D=>115.02694,
 E=>129.04259,
 F=>147.06841,
 G=>57.02146,
 H=>137.05891,
 I=>113.08406,
 K=>128.09496,
 L=>113.08406,
 M=>131.04049,
 N=>114.04293,
 P=>97.05276,
 Q=>128.05858,
 R=>156.10111,
 S=>87.03203,
 T=>101.04768,
 V=>99.06841,
 W=>186.07931,
 Y=>163.06333
);

sub ProteinWeight
{
    my ($aa) = @_;
    my $result;
    for (my $i = 0 ; $i < length($aa) ; ++$i)
    {
	$result += $pweight{substr($aa,$i,1)};
    }
    return $result;
}

sub WeightProtein
{
    my ($w) = @_;
    my @sar = keys %pweight;

    @sar = sort { abs($pweight{$a}-$w) <=> abs($pweight{$b}-$w) } @sar;
    return $sar[0];
}
