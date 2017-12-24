BEGIN { push @INC,"../common"; }
use codon;

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$str = <FD>;
$str =~ s/\r?\n$//;

$ss = <FD>;
$ss =~ s/\r?\n$//;

close FD;

my $ssi = 0;
for (my $i = 0 ; $i < length $str ; ++$i)
{
    next if substr($ss,$ssi,1) ne substr($str,$i,1);
    ++$ssi;
    print $i+1;
    print " ";
    last if $ssi == length($ss);
}



