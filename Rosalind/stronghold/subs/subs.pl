die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$str = <FD>;
$subs = <FD>;
close FD;
$str =~ s/\r?\n$//;
$subs =~ s/\r?\n$//;

$curi = 0;

while(($mi = index($str,$subs,$curi)) != -1)
{
    print $mi+1," ";
    $curi = $mi+1;
}
print "\n";
