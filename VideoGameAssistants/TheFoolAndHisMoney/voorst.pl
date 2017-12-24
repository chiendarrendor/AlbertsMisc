# organizes all words in voorst.txt by three-letter substring


open(FD,"voorst.txt");
while (<FD>)
{
    s/\r?\n$//;
    push @words,$_;
}
close(FD);


for ($i = 0 ; $i < @words ; ++$i)
{
    for ($j = 0 ; $j < 5 ; ++$j)
    {
	$sub = substr($words[$i],$j,3);
	push(@{$subs{$sub}},$words[$i]);
    }
}

foreach $key (keys %subs)
{
    $aref = $subs{$key};
    next unless @$aref > 1;
    print "$key: ",join(",",@$aref),"\n";
}


