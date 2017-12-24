use Utility;

# solves the 'O' puzzles
# takes three arguments
# larger grid
#
# aaa   ccc
# aaa   ccc
# aaabbbccc
#    bbb
#    bbb
# arguments: aaaaaaaaa bbbbbbbbb cccccccc
#
# first argument is either 'U' or 'D', determining whether the center block is Down
# as pictured, or Up


my %threewords;
for my $word (split("\n",`grep -E \'^...$\' words`))
{
    $threewords{$word} = 1;
}
print scalar keys %threewords, " three-letter words loaded\n";

my %ninewords;
for my $word (split("\n",`grep -E \'^.{9}$\' words`))
{
    $ninewords{$word} = 1;
}
print scalar keys %ninewords, " nine-letter words loaded\n";

sub IsWord
{
    my ($aryref,@nums) = @_;
    my $word = $aryref->[$nums[0]] . $aryref->[$nums[1]] . $aryref->[$nums[2]];
    return exists $threewords{$word};
}

sub WordGrids
{
    my ($letters) = @_;
    my @letar = split("",$letters);
    my $perms = Utility::PermuteArray(\@letar);
    my %uniques;
    my $result = [];
    for my $perm (@$perms)
    {
	next unless IsWord($perm,0,1,2);
	next unless IsWord($perm,3,4,5);
	next unless IsWord($perm,6,7,8);
	next unless IsWord($perm,0,3,6);
	next unless IsWord($perm,1,4,7);
	next unless IsWord($perm,2,5,8);
	my $key = join(",",@$perm);
	next if exists $uniques{$key};
	push @$result,$perm;
	$uniques{$key} = 1;
    }
    return $result;
}











# 012
# 345
# 678


die("bad command line") unless @ARGV == 4;
$type = shift @ARGV;
die("Bad type") unless $type eq 'U' || $type eq 'D';

my @ary;
for $row (@ARGV)
{
    die("bad command word") unless length($row) == 9;
}

my $agrids = WordGrids($ARGV[0]);
print scalar @$agrids," a grids found\n";
my $bgrids = WordGrids($ARGV[1]);
print scalar @$bgrids," b grids found\n";
my $cgrids = WordGrids($ARGV[2]);
print scalar @$cgrids," c grids found\n";

for my $agrid (@$agrids)
{
    for my $bgrid (@$bgrids)
    {
	for my $cgrid (@$cgrids)
	{
	    if ($type eq 'D')
	    {
		$nineword = join("",@$agrid[6..8],@$bgrid[0..2],@$cgrid[6..8]);
	    }
	    else
	    {
		$nineword = join("",@$agrid[0..2],@$bgrid[6..8],@$cgrid[0..2]);
	    }

	    next unless exists $ninewords{$nineword};


	    print "---------\n";

	    if ($type eq 'D')
	    {
		print join("",@$agrid[0..2]),"   ",join("",@$cgrid[0..2]),"\n";
		print join("",@$agrid[3..5]),"   ",join("",@$cgrid[3..5]),"\n";
		print join("",@$agrid[6..8]),join("",@$bgrid[0..2]),join("",@$cgrid[6..8]),"\n";
		print "   ",join("",@$bgrid[3..5]),"\n";
		print "   ",join("",@$bgrid[6..8]),"\n";
	    }
	    else
	    {
		print "   ",join("",@$bgrid[0..2]),"\n";
		print "   ",join("",@$bgrid[3..5]),"\n";
		print join("",@$agrid[0..2]),join("",@$bgrid[6..8]),join("",@$cgrid[0..2]),"\n";
		print join("",@$agrid[3..5]),"   ",join("",@$cgrid[3..5]),"\n";
		print join("",@$agrid[6..8]),"   ",join("",@$cgrid[6..8]),"\n";
	    }
	}
    }
}

