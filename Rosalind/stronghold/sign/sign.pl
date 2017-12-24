BEGIN { push @INC,"../common"; }
use Utility;

die("bad command line") unless @ARGV == 1;
$n = $ARGV[0];

for (my $i = 1 ; $i <= $n ; ++$i)
{
    push @ar,$i;
}

for (my $i = 0 ; $i < 2**$n ; ++$i)
{
    my $r = [];
    for (my $j = 0 ; $j < $n ; ++$j)
    {
	my $v = ($i >> $j) & 0x1;
	push @$r,($v ? 1 : -1);
    }
    push @signs,$r;
}


my $res = Utility::PermuteArray(\@ar);
my $count = scalar @$res * scalar @signs;
print "$count\n";

for $p (@$res)
{
    for $s (@signs)
    {
	for ($i = 0 ; $i < $n ; ++$i)
	{
	    print($p->[$i] * $s->[$i]);
	    print " ";
	}
	print "\n";
    }
}
