die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$str = <FD>;
close FD;
$str =~ s/\r?\n$//;
my @gcar = split(" ",$str);

for $gc (@gcar)
{
    $cf = $gc / 2.0;
    $gf = $gc / 2.0;
    $af = (1.0-$gc)/2.0;
    $tf = (1.0-$gc)/2.0;

    printf("%.6f ",$cf*$cf+$gf*$gf+$af*$af+$tf*$tf);
}
print "\n";
