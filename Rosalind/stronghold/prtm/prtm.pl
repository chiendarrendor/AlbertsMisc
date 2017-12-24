BEGIN { push @INC,"../common"; }
use codon;

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$str = <FD>;
close FD;
$str =~ s/\r?\n$//;

my $w = 0;
for ($i = 0 ; $i < length($str) ; ++$i)
{
    $aa = substr($str,$i,1);
    $w += codon::ProteinWeight($aa);
}
printf("%.2f\n",$w);
