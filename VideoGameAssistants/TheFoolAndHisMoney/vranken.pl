open(FD,"vranken.txt");

while(<FD>)
{
    s/\r?\n//;
    $word = $_;
    $vowels = $word;
    $vowels =~ tr/aeiou//dc;
    @vowels = split("",$vowels);
    @vowels = sort @vowels;
    $vowels = join("",@vowels);

    push @{$vtrip{$vowels}},$word;
}

foreach $key (keys %vtrip)
{
    $aref = $vtrip{$key};
    print $key,": ",join(",",@$aref),"\n";
}
