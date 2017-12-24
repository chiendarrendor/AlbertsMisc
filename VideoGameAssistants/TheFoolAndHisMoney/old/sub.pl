die("bad command line") unless @ARGV == 2;
$base = $ARGV[0];
$subs = $ARGV[1];

for (my $i = 0 ; $i < length($subs) ; ++$i)
{
    my $c = substr($subs,$i,1);
    my $k = index($base,$c);
    die("mrrr?") if $k == -1;
    substr($base,$k,1,'');
}

print $base,"\n";
