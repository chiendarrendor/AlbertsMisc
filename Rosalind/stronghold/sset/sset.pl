
die("bad command line") unless @ARGV == 1;

$n = $ARGV[0];

$r = 1;
for (my $i = 0 ; $i < $n ; ++$i)
{
    $r = ($r * 2) % 1000000;
}

print "$r\n";
