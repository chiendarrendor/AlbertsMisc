BEGIN { push @INC,"../common"; }
use codon;

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$str = <FD>;
close FD;
$str =~ s/\r?\n$//;

print codon::Translate($str),"\n";

