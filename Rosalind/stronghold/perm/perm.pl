BEGIN { push @INC,"../common"; }
use Utility;

die("bad command line") unless @ARGV == 1;
$n = $ARGV[0];

for (my $i = 1 ; $i <= $n ; ++$i)
{
    push @ar,$i;
}
my $res = Utility::PermuteArray(\@ar);
print scalar @$res,"\n";
for $p (@$res)
{
    print join(" ",@$p),"\n";
}
