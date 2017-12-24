open(FD,"vanderveer.txt");

# add words to this list as you guess that they are right
@mwords = (
    giraffe, agitate, regular, forgive, amongst, sausage, backlog,
    keyhole, sketchy, awkward, hickory, whiskey, mistake, mollusk,
    caramel, scholar, lacquer, sorcery, vehicle, avarice, shellac,
    trivial, stylish, extreme, feather, visitor, reality, assault,
    believe, obvious, library, eyeball, visible, lullaby, disturb,
    warrior, swallow, jewelry, haywire, faraway, shadowy, rainbow,
    dismiss, odyssey, elderly, humdrum, residue, already, emerald
    );

for ($i = 0 ; $i < @mwords ; ++$i)
{
    $mwords{$mwords[$i]} = 1;
}

while(<FD>)
{
    s/\r?\n//;
    next if exists $mwords{$_};

    for ($i = 0 ; $i < length($_) ; ++$i)
    {
	$let = substr($_,$i,1);
	push(@{$words{$let}->{$i}},$_);
    }
}
close(FD);

foreach $key (keys %words)
{
    for ($i = 0 ; $i < 7 ; ++$i)
    {
	last if (!exists $words{$key}->{$i});
    }
    if ($i < 7)
    {
	delete $words{$key};
    }
}



foreach $key(keys %words)
{
    for ($i = 0 ; $i < 7 ; ++$i)
    {
	$wlist = $words{$key}->{$i};
	for $word (@$wlist)
	{
	    push(@{$worddata{$word}},"$key$i");
	}
    }
}


foreach $key (sort keys %words)
{
    print "$key:\n";
    $done = 0;
    $llist = $words{$key};
    $lcount = 0;
    while(!$done)
    {
	$done = 1;
	for ($i = 0 ; $i < 7 ; ++$i)
	{
	    if (!exists $llist->{$i} ||
		!exists $llist->{$i}->[$lcount])
	    {
		print "\t";
		next;
	    }
	    $done = 0;
	    print $llist->{$i}->[$lcount],"\t";
	}
	++$lcount;
	print "\n";
    }
}

foreach $key (sort keys%worddata)
{
    $aref = $worddata{$key};
    print "$key: ",join(",",@$aref),"\n";
}



		


