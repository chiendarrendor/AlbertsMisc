@letters = ("y","s","h","e","b","t","p","g","c","a");
@actors = ("aelr","agnr","alor","eemr","ails",
	   "abyb","aeht","acer","anom","tifh");

for $fl (split("\n",`grep -E '^.{5}\$' words | tr -d '\015'`))
{
    $fives{$fl} = 1;
}

print "fives loaded\n";

use Utility;

for $actor (@actors)
{
    @aar = split(//,$actor);
    push @aar,"_";

    $perms = Utility::PermuteArray(\@aar);

    print "$actor permuted\n";

    for $perm (@$perms)
    {
	my $repl;
	for ($repl = 0; $repl < @$perm ; ++$repl)
	{
	    last if $perm->[$repl] eq '_';
	}
	for $let (@letters)
	{
	    $perm->[$repl] = $let;
	    $word = join("",@$perm);
	    next unless exists $fives{$word};

	    push @{$matrix{$let . "_" . $actor}},$word;
	}
    }
}

for $key (sort keys %matrix)
{
    print $key,": ",join(",",@{$matrix{$key}}),"\n";
}
    
	
	
