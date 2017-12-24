
@words = split("\r\n",`cat vranken.txt`);

for $word (@words)
{
    $vowels = $word;
    $vowels =~ y/aeiou//cd;
    $vowels = join("",sort split(//,$vowels));

    push @{$byvowel{$vowels}},$word;
}

for $vowel (keys %byvowel)
{
    print $vowel,":";
    for $word (@{$byvowel{$vowel}})
    {
	print " ",$word;
    }
    print "\n";
}




