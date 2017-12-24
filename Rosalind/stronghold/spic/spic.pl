BEGIN { push @INC,"../common"; }

use codon;

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");

$exon = <FD>;
$exon =~ s/\r?\n$//;
while(<FD>)
{
    $_ =~ s/\r?\n$//;
    $exon =~ s/$_//g;
}

$exon =~ s/T/U/g;

print codon::Translate($exon),"\n";



