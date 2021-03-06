BEGIN { push @INC,"../common"; }

use SuffixTree;
use StringWrapper;
use SubString;

my $sw;
my $olen;
sub LoadFile
{
    my ($name) = @_;
    open (FD,$name) || die("Can't open file");
    my $str = <FD>;
    $str =~ s/\r?\n$//;
    $olen = length($str);
    $str .= '$' unless $str =~ /\$$/;
    $sw = new StringWrapper($str);
    close FD;
}

sub min
{
    my ($a,$b) = @_;
    return $a < $b ? $a : $b;
}


die("bad command line") unless @ARGV;
LoadFile($ARGV[0]);

print "load complete\n";

$st = new SuffixTree($sw);

print "suffixtree complete\n";

$stotal = $st->CountByLength();


print "Count by length complete\n";

my $switch = 0;

for (my $i = 1 ; $i <= $olen ; ++$i)
{
    if ($switch == 0)
    {
	$perms = 4 ** $i;
	$nums = ($olen-$i)+1;
	$switch = 1 if ($perms > $nums);
    }
    else
    {
	$nums = ($olen-$i)+1;
	$perms = $nums;
    }

    $m = min($perms,$nums);
    $mtotal += $m;
}


printf("%.4f\n",$stotal / $mtotal);










