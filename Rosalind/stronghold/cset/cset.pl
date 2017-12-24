BEGIN { push @INC,"../common"; }

use CharacterTaxonomy;

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");

while(<FD>)
{
    $_ =~ s/\r?\n$//;
    push @characters,$_;
}
close(FD);

#  we are informed that, among the set of n characters, there is an n-1 subset
# that is self-consistent.  so we'll try all n-1 n-1-subsets until we find the right one.

my $clength = length($characters[0]);

for (my $i = 0 ; $i < @characters ; ++$i)
{
    $ct = new CharacterTaxonomy($clength);
    my $good = 1;
    for (my $j = 0 ; $j < @characters ; ++$j)
    {
	next if $i == $j;

	if (!$ct->ProcessCharacter($characters[$j]))
	{
	    $good = 0;
	    last;
	}
    }
    next unless $good;

    for (my $j = 0 ; $j < @characters ; ++$j)
    {
	next if $i == $j;
	print $characters[$j],"\n";
    }
    last;
}

