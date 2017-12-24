die("bad command line") unless @ARGV == 2;
$n = $ARGV[0];
$k = $ARGV[1];

my $r = 1;
for (my $i = 0 ; $i < $k ; ++$i)
{
    $r = ($r * ($n - $i)) % 1000000;
}

print "$r\n";

    
