@trips =
(
 "ace",
 "ail",
 "ass",
 "car",
 "ele",
 "end",
 "hem",
 "ice",
 "leg",
 "mat",
 "men",
 "not",
 "per",
 "pet",
 "pot",
 "tea",
 "use",
 "ant",
 "for"
);

sub Highlight
{
    my ($word,$skip) = @_;
    my $result = $word;
    for my $test (@trips)
    {
	next if $test eq $skip;
	my $idx = index($word,$test);
	next if $idx == -1;
	substr($result,$idx,3,uc($test));
    }
    return $result;
}



for $trip (@trips)
{
    print $trip,":";
    my @words = split("\n",`grep $trip vibbard.txt`);
    for $word (@words)
    {
	print " ",Highlight($word,$trip);
    }
    print "\n";
}
