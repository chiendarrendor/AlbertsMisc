BEGIN { push @INC,"../Common/Perl"; }
use Permute;


my @words;
my @indices;
my @permi;

while(@ARGV)
{
    $item = shift @ARGV;
    if ($item =~ /^[a-z]+$/)
    {
	push @permi,scalar @permi;
	push @words,$item;
    }
    elsif ($item =~ /^[0-9]+$/)
    {
	push @indices,$item;
    }
    else
    {
	die("unknown command line arg");
    }
}
die("words count differs from index count") unless @words == @indices;
die("no words") unless @words;


my @perms = Permute::PermuteArray(@permi);
for $perm (@perms)
{
    for (my $i = 0 ; $i < @words ; ++$i)
    {
	$w = $words[$perm->[$i]];
	$idx = $indices[$i];
	print substr($w,$idx,1);
    }
    for (my $i = 0 ; $i < @words ; ++$i)
    {
	print "  ",$words[$perm->[$i]];
    }
    print "\n";
}
