die("bad command line") unless @ARGV == 1;
$n = $ARGV[0];

if ($n < 3) {print "0";}
else {print $n - 2;}
print "\n";

