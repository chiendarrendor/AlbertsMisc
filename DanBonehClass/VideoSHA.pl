use Digest::SHA;
use BlockRead;
use Utils;


die("Bad Command Line\n") unless @ARGV == 1;
my $fname = $ARGV[0];



my @blocks = BlockRead::BlockRead($fname,1024);

#print Utils::bintohex($blocks[0]),"\n";
#print Utils::bintohex($blocks[@blocks-1]),"\n";

my $state = Digest::SHA->new(256);
for (my $i = 0 ; $i < @blocks ; ++$i)
{
	$state->add($blocks[$i]);
}

print Utils::bintohex($state->digest),"\n";

$state->reset();
$state->addfile($fname);
print Utils::bintohex($state->digest),"\n";
exit(1);


for (my $i = ((scalar @blocks) - 1) ; $i >= 1 ; --$i )
{
	my $digest = Digest::SHA::sha256($blocks[$i]);
#	print "pre: ",length($blocks[$i-1]);
	$blocks[$i-1] .= $digest;
#	print " post: ",length($blocks[$i-1]),"\n";
}

print Utils::bintohex(Digest::SHA::sha256($blocks[0])),"\n";





