use Math::BigInt;

sub BIfac
{
    my ($n) = @_;
    my $result = Math::BigInt->bone();

    for (my $i = 2 ; $i <= $n ; ++$i)
    {
	my $x = Math::BigInt->new($i);
	$result->bmul($x);
    }
    return $result;
}

sub BIcomb
{
    my ($n,$k) = @_;
    my $nf = BIfac($n);
    my $kf = BIfac($k);
    my $nkf = BIfac($n - $k);
    return $nf->bdiv($kf)->bdiv($nkf);
}

die("bad command line") unless @ARGV == 2;

my $lastgen = $ARGV[0];
my $minorgs = $ARGV[1];

sub max
{
    my ($a,$b) = @_;
    return $a > $b ? $a : $b;
}

sub min
{
    my ($a,$b) = @_;
    return $a < $b ? $a : $b;
}


sub comb
{
    my ($n,$k) = @_;
    my @war;
    my @left;

#    print "  ($n,$k)\n";

    # 1) find n!
    for (my $i = 2 ; $i <= $n ; ++$i)
    {
	unshift @war,$i;
    }

#    print "  n!: ",join(",",@war),"\n";

    # 2) divide this by k!
    while($war[@war-1] <= $k && @war)
    {
	pop @war;
    }

#    print "  n!/k!: ",join(",",@war),"\n";

    # 3) divide this by (n-k)!
    # this one is tricky, 
    # since we've already removed k!
    # however, we are in luck, because:
    # there should be as many terms left in @war
    # as there are terms in (n-k)!
    # so we should be able to find one to divide
    # (pigeonhole principle + modulo arithmetic)
    #
    # if we are looking for something to divide by 5:
    # war: 6 5 4 3 2
    # mod: 1 0 4 3 2

    my $o0 = $war[0];

    for (my $i = $n - $k ; $i >= 2 ; --$i)
    {
	my $fn =  $o0 % $i;
	
	my $found = 0;
	for($j = $fn ; $j < @war ; ++$j)
	{
	    next if ($war[$j] % $i) != 0;
	    $war[$j] /= $i;
#	    print "    $i removed from $j\n";
	    $found = 1;
	    last;
	}
	push @left,$i unless $found;
    }

#    print "  n!/k!/(n-k)!: ",join(",",@war),"\n";

	
    my $r = 1;
    for my $i (@war) { $r *= $i; }

    my $le = 1;
    for my $i (@left) { $le *= $i; }

    return $r/$le;
}



sub Mendel
{
    my ($t1,$t2) = @_;
    my $result = {};

    for (my $i = 0 ; $i < 2 ; ++$i)
    {
	my $c1 = substr($t1,$i,1);
	for (my $j = 0 ; $j < 2 ; ++$j)
	{
	    my $c2 = substr($t2,$j,1);
	    my $k;
	    if ($c1 eq $c2) { $k = $c1 . $c2; }
	    else { $k = "Aa"; }
	    
	    ++$result->{$k};
	}
    }
    for my $k (keys %$result)
    {
	$result->{$k} /= 4.0;
    }
    return $result;
}

my $mate = "Aa";

my $o1 = Mendel("Aa",$mate);

my $gen1 = [$o1];

my $curgen = $gen1;
my $gennum = 1;

while($gennum < $lastgen)
{
    ++$gennum;
    my $nextgen = [];

    for (my $i = 0 ; $i < @$curgen ; ++$i)
    {
	my $co = $curgen->[$i];

	for my $k (keys %$co)
	{
	    my $newo = Mendel($k,$mate);
	    for my $nk (keys %$newo)
	    {
		$newo->{$nk} *= $co->{$k};
	    }
	    push @$nextgen,$newo;
	}
    }
    $curgen = $nextgen;
}

for (my $i = 0 ; $i < @$curgen ; ++$i)
{	    
    for my $k (keys %{$curgen->[$i]})
    {
	$res{$k} += $curgen->[$i]->{$k};
    }

    print join(",",%{$curgen->[$i]}),"\n";
}

my $fcount = 2**$lastgen;
print "count: ",$fcount,"\n";
print join(",",%res),"\n";

# we want the binomial probability of 
# $minorgs success in $fcount trials, where 
# the probability of success is $res{Aa}

my $result = 0;
my $p = $res{Aa} * $res{Aa};
for (my $i = $minorgs ; $i <= $fcount ; ++$i)
{
    my $co = comb($fcount,$i);
    my $c = $co * ($p ** $i) * ((1-$p)**($fcount-$i));
    $result += $c;
    print "$i: $c   ",$co," --- ",BIcomb($fcount,$i)->bstr(),"\n";
}

printf("%.3f\n",$result);



