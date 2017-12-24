use Utility;

die("bad command line") unless @ARGV == 1;

my @war = split("",$ARGV[0]);

my $res = Utility::PermuteArray(\@war);
for $r (@$res)
{
    print join("",@$r),"\n";
}
