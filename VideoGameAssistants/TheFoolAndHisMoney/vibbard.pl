# organizes all words in voorst.txt by three-letter substring


open(FD,"vibbard.txt");
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
    next unless @$aref > 3;
    for ($i = 0 ; $i < @$aref; ++$i)
    {
	push(@{$joins{$aref->[$i]}},$key);
    }    
}

print "triplet joins: ","\n";
foreach $key (keys %joins)
{
    $aref = $joins{$key};
    next unless @$aref > 1;
    print "$key: ",join(",",@$aref),"\n";
}

print "triplet constituients:","\n";
foreach $key (keys %subs)
{
    $aref = $subs{$key};
    next unless @$aref > 3;
    print "$key: ",join(",",@$aref),"\n";
}


