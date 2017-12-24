
my $letters = "noowfrlod";

die("bad command line") unless @ARGV == 1;

my $w = $ARGV[0];

for ($i = 0 ; $i < length($w) ; ++$i)
{
    $c = substr($w,$i,1);

    $idx = index($letters,$c);
    die("word not in letters\n") if $idx == -1;
    substr($letters,$idx,1,'');
}
print "final: $letters\n";

    
