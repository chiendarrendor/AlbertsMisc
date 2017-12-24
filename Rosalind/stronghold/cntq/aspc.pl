use Math::BigInt;

sub BIprod
{
    my (@ar) = @_;
    my $result = Math::BigInt->bone();
    for my $v (@ar)
    {
	my $x = Math::BigInt->new($v);
	$result->bmul($x);
    }
    return $result;
}


sub BIfac
{
    my ($n,$k) = @_;

    $k = 1 unless $k;

    my $result = Math::BigInt->bone();

    for (my $i = $k+1 ; $i <= $n ; ++$i)
    {
	my $x = Math::BigInt->new($i);
	$result->bmul($x);
    }
    return $result;
}

sub BIcomb
{
    my ($n,$k) = @_;

    my $nkb = $k > $n-$k ? $k : $n-$k;
    my $nks = $k > $n-$k ? $n-$k : $k;

    my @war;
    my @left;
    for (my $i = $n ; $i > $nkb ; --$i)
    {
	push @war,$i;
    }

    my $owar = $war[0];
    for (my $i = $nks ; $i >= 2; --$i)
    {
	my $fidx = $owar % $i;
	my $found = 0;
	for (my $j = $fidx ; $j < @war ; $j += $i)
	{
	    next unless ($war[$j] % $i) == 0;
	    $war[$j] /= $i;
	    $found = 1;
	    last;
	}
	push @left,$i unless $found;
    }

#    print "war: ",join(",",@war),"\n";
#    print "left: ",join(",",@left),"\n";


    my $nf = BIprod(@war);
    my $kf = BIprod(@left);

#    print "nf: ",$nf->bstr(),"\n";
#    print "kf: ",$kf->bstr(),"\n";

    my $r = $nf->bdiv($kf);
    return $r;
}

#$c = BIcomb(1500,350);
#print "what is c? ",ref $c,"\n";
#print "C: ",$c->bstr(),"\n";
#exit(0);


die("bad command line") unless @ARGV == 1;

$n = $ARGV[0];

my $modulus = Math::BigInt->new(1000000);
$c = BIcomb($n,4)->bmod($modulus)->bstr();
print $c,"\n";


