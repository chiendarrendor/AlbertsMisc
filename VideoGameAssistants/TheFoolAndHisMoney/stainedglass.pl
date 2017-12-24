
die ("bad command line: letters <L/R> [comlength] \n") unless @ARGV>=2;
my $letters = $ARGV[0];

my @wordlengths = (5,6,7);
if (@ARGV == 3)
{
    $comlength = $ARGV[2];
    my $diff = 4 - $comlength;
    for (my $i = 0 ; $i < @wordlengths ; ++$i) { $wordlengths[$i] -= $diff; }
}
else
{
    $comlength = 4;
}

if ($ARGV[1] eq 'L') { $comstart = 0; }
elsif ($ARGV[1] eq 'R') { $comstart = -$comlength; }
else { die("bad direction specifier\n"); }


    
my $filtergrep = '| grep -E -v \'(.).*\\1\'';

# 1: for each length of word in @wordlengths,
#    find all words in 'words' that contain the letters in letters
my @wordlist;
for my $length (@wordlengths)
{
    my $greparg = "'^[" . $letters . "]{" . $length . "}\$'";
    push @wordlist,split("\n",`grep -E $greparg words $filtergrep`);
}

# 2. group all the words of all lengths together by
#     common comlength/comstart properties (negative
#     comstart means to start that far back from the end
my %grouphash;
for my $word (@wordlist)
{
    my $wlength = length($word);
    my $key = substr($word,$comstart,$comlength);
    if (!exists $grouphash{$key})
    {
	$grouphash{$key} = {};
    }
    if (!exists $grouphash{$key}->{$wlength})
    {
	$grouphash{$key}->{$wlength} = [];
    }
    push @{$grouphash{$key}->{$wlength}},$word;
}

# 3. print all words from all groups that have at least
#    one word of each length.

my $numskipped = 0;
for my $key (sort keys %grouphash)
{
    my $group = $grouphash{$key};
    if (scalar keys %$group != scalar @wordlengths)
    {
	++$numskipped;
	next;
    }
    print $key,"(";

    for (my $i = 0 ; $i < length($letters) ; ++$i)
    {
	if (index($key,substr($letters,$i,1)) == -1)
	{
	    print substr($letters,$i,1);
	}
    }

    print "): ";
    for my $wl (@wordlengths)
    {
	print join(",",@{$group->{$wl}})," ";
    }
    print "\n";
}
print "$numskipped skipped\n";


