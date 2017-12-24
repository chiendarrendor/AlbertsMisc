BEGIN { push @INC,"../common"; }

use SuffixTree;
use StringWrapper;
use SubString;

my $sw;
my $repeat;
sub LoadFile
{
    my ($name) = @_;
    open (FD,$name) || die("Can't open file");
    my $str = <FD>;
    $str =~ s/\r?\n$//;
    $str .= '$' unless $str =~ /\$$/;
    $sw = new StringWrapper($str);
    $repeat = <FD>;
    $repeat =~ s/\r?\n$//;
    close FD;
}


die("bad command line") unless @ARGV;
LoadFile($ARGV[0]);

$st = new SuffixTree($sw);

print "----\n";
$st->Print();
print "----\n";

$ss = $st->FindCommonSubstrings();

for $sub (@$ss)
{
    print $sub->[1],": ",$sub->[0]->ToString(),"\n";
}


@filtered = grep { $_->[1] >= $repeat } @$ss;

@ordered = sort { $b->[0]->Length() <=> $a->[0]->Length() } @filtered;

print $ordered[0]->[0]->ToString(),"\n";





