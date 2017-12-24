
sub permute
{
    my ($string) = @_;
    my @result;

    if (length($string) == 1)
    {
	push @result,$string;
	return @result;
    }

    my $i;
    my $j;
    for ($i = 0 ; $i < length($string) ; ++$i)
    {
	my $strcpy = $string;
	my $ch = substr($strcpy,$i,1);
	substr($strcpy,$i,1,'');
	my @subresult = permute($strcpy);
	my $tstr;
	for ($j = 0 ; $j < @subresult ; $j++)
	{
	    $tstr = $ch . $subresult[$j];
	    push @result,$tstr;
	}
    }
    return @result;
}




open(WORDS,"words.txt") || die("Can't open words.txt");
my %words;
while(<WORDS>)
{
    chomp;
    ($word,$def) = $_ =~ /^(\S+)\s+(.+)$/;
    $words{$word} = 1;
}

close(WORDS);

sub IsWord
{
    my ($string,$a,$b,$c) = @_;
    my $newstr = 
	substr($string,$a,1) . 
	substr($string,$b,1) . 
	substr($string,$c,1);

    return exists($words{$newstr});
}

	


die("bad command line") unless @ARGV == 2;
$origstring = $ARGV[0];
$fixcell = $ARGV[1];
die("Bad string") unless length($origstring) == 9;

# 0 1 2
# 3 4 5
# 6 7 8

my @perms = permute($origstring);
for ($i = 0 ; $i < @perms ; ++$i)
{
    my $p = $perms[$i];
    next unless (substr($p,$fixcell,1) eq substr($origstring,$fixcell,1));
    next unless IsWord($p,0,1,2);
    next unless IsWord($p,3,4,5);
    next unless IsWord($p,6,7,8);
    next unless IsWord($p,0,3,6);
    next unless IsWord($p,1,4,7);
    next unless IsWord($p,2,5,8);
    print "$p\n";
}

