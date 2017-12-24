die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$str = <FD>;
close FD;
$str =~ s/\r?\n$//;

for (my $i = 0 ; $i < length($str) ; ++$i) { $result[$i] = 0; }

for (my $len = 1 ; $len < length($str)-1 ; ++$len)
{
    my $iss = substr($str,0,$len);

    my $si = 1;
    while(1)
    {
	$si = index($str,$iss,$si);
	last if $si == -1;
	$result[$si+$len-1] = $len;
	++$si;
    }
}

print join(" ",@result),"\n";

