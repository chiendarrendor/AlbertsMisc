die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$str1 = <FD>;
$str2 = <FD>;
close FD;
$str1 =~ s/\r?\n$//;
$str2 =~ s/\r?\n$//;

$result = 0;
for ($i = 0 ; $i < length($str1) ; ++$i)
{
    ++$result unless substr($str1,$i,1) eq substr($str2,$i,1);
}
print $result,"\n";


