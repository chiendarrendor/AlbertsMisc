BEGIN { push @INC,"../common"; }
use codon;

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$str = <FD>;
close FD;
$str =~ s/\r?\n$//;

my $pcount = codon::ProteinCounts();

my $res = 1;
for ($i = 0 ; $i < length($str) ; ++$i)
{
    my $aa = substr($str,$i,1);
    my $lc = $pcount->{$aa};
    $res = ($res * $lc) % 1000000;
}

# stop codons
$res = ($res * codon::StopCount()) % 1000000;

print $res,"\n";


