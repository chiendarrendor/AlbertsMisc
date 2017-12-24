BEGIN { push @INC,"../common"; }
use codon;

sub SpectralConvolution
{
    my ($ar,$br) = @_;

    my $result = {};
    for (my $i = 0 ; $i < @$ar ; ++$i)
    {
	for (my $j = 0 ; $j < @$br ; ++$j)
	{
	    my $d = $ar->[$i] - $br->[$j];
	    ++$result->{sprintf("%.5f",$d)};
	}
    }

    return $result;
}
	
sub MaxMultiplicity
{
    my ($conv) = @_;
    my $result = 0;
    for my $key (keys %$conv)
    {
	$result = $conv->{$key} if $conv->{$key} > $result;
    }
    return $result;
}

sub GetSpectrum
{
    my ($prot) = @_;
    my $result = [];
    for (my $len = 1 ; $len <= length($prot) - 1 ; ++$len)
    {
	my $ss1 = substr($prot,0,$len);
	my $ss2 = substr($prot,$len);
	push @$result,codon::ProteinWeight($ss1);
	push @$result,codon::ProteinWeight($ss2);
    }
    return $result;
}


die("bad command line") unless @ARGV;

open(FD,$ARGV[0]) || die("can't open file");
$count = <FD>;
$count =~ s/\r?\n$//;

for (my $i = 0 ; $i < $count ; ++$i)
{
    $_ = <FD>;
    $_ =~ s/\r?\n$//;
    push @prots,{PROTEIN=>$_,SPECTRUM=>GetSpectrum($_)};
}
while(<FD>)
{
    $_ =~ s/\r?\n$//;
    push @$testspectrum,$_;
}
close FD;

my $maxmult = 0;
my $bestprot = undef;
for $p (@prots)
{
    $mult = MaxMultiplicity(SpectralConvolution($p->{SPECTRUM},$testspectrum));
    if ($mult > $maxmult)
    {
	$maxmult = $mult;
	$bestprot = $p;
    }
}

print $maxmult,"\n";
print $bestprot->{PROTEIN},"\n";



