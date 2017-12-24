BEGIN { push @INC,"../common"; }

use SuffixTree;
use StringWrapper;
use SubString;

my $sw;
sub LoadFile
{
    my ($name) = @_;
    open (FD,$name) || die("Can't open file");
    my $str = <FD>;
    $str =~ s/\r?\n$//;
    $str .= '$' unless $str =~ /\$$/;
    $sw = new StringWrapper($str);
    close FD;
}


die("bad command line") unless @ARGV;
LoadFile($ARGV[0]);

$st = new SuffixTree($sw);
$st->PrintAllEdges();





