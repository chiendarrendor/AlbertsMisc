BEGIN { push @INC,"../Common/Perl"; }
use Permute;

$word = @ARGV[0];

my @perms = Permute::Permute($word);
for $perm (@perms)
{
    print $perm,"\n";
}
