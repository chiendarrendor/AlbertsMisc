BEGIN { push @INC,"../common"; }
use codon;

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$str = <FD>;
close FD;
$str =~ s/\r?\n$//;

for (my $i = 0 ; $i < length($str) ; ++$i)
{
    my $s1 = substr($str,$i,1);
    for (my $j = $i+4 ; $j < length($str) ; ++$j)
    {
	my $s2 = substr($str,$j,1);
	if (($s1 eq "A" && $s2 eq "U") ||
	    ($s1 eq "U" && $s2 eq "A") ||
	    ($s1 eq "C" && $s2 eq "G") ||
	    ($s1 eq "G" && $s2 eq "C") ||
	    ($s1 eq "G" && $s2 eq "U") ||
	    ($s1 eq "U" && $s2 eq "G"))
	{
	    my $ne = { I1=>$i,I2=>$j };
	    push @bonds,$ne;
	}
    }
}

sub NodeName
{
    my ($n) = @_;
    return $n->{I1} . "-" . $n->{I2};
}

print scalar @bonds,"\n";

for $b1 (@bonds)
{
    for $b2 (@bonds)
    {
	if (($b1->{I1} == $b2->{I1}) ||
	    ($b1->{I1} == $b2->{I2}) ||
	    ($b1->{I2} == $b2->{I1}) ||
	    ($b1->{I2} == $b2->{I2}) ||
	    ($b1->{I1} < $b2->{I1} && $b2->{I1} < $b1->{I2}) ||
	    ($b1->{I1} < $b2->{I2} && $b2->{I2} < $b1->{I2}) ||
	    ($b2->{I1} < $b1->{I1} && $b1->{I1} < $b2->{I2}) ||
	    ($b2->{I1} < $b1->{I2} && $b1->{I2} < $b2->{I2}))
	{
	    push @{$b1->{SIBLINGS}},$b2;
	}
	else
	{
	    next;
	}
    }
}

for $b (@bonds) 
{
    print NodeName($b),": ";
    for $s (@{$b->{SIBLINGS}})
    {
	print NodeName($s)," ";
    }
    print "\n";
}


	
	
	    

