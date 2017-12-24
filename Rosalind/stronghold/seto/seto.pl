BEGIN { push @INC,"../common"; }
use Set;

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$size = <FD>;
$size =~ s/\r?\n$//;
$ustr = '{';
for (my $i = 1 ; $i <= $size ; ++$i) 
{ 
    if ($i != 1) { $ustr .= ',' };
    $ustr .= $i;
}
$ustr .= '}';

$u = new Set($ustr);

$str1 = <FD>;
$str1 =~ s/\r?\n$//;
$s1 = new Set($str1);

$str2 = <FD>;
$str2 =~ s/\r?\n$//;
$s2 = new Set($str2);

close FD;

print $s1->Union($s2)->ToString(),"\n";
print $s1->Intersect($s2)->ToString(),"\n";
print $s1->Minus($s2)->ToString(),"\n";
print $s2->Minus($s1)->ToString(),"\n";
print $u->Minus($s1)->ToString(),"\n";
print $u->Minus($s2)->ToString(),"\n";



