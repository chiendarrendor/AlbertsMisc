# harpist 
# shortly 
# ethical
# sighted
# warthog
# upright
# anguish

@words = split("\r\n",`cat vandermeer.txt`);

for $word (@words)
{
    @war = split(//,$word);
    for (my $i = 0 ; $i < @war ; ++$i)
    {
	push @{$breakout{$war[$i]}->{$i}},$word;
    }
}

for $lkey (sort keys %breakout)
{
    my $breakblock = $breakout{$lkey};
    next unless scalar keys %$breakblock == 7;
    print $lkey,":\n";
    for $ikey (sort keys %$breakblock)
    {
	$pkey = $ikey + 1;

	print "$pkey:";
	for $word (@{$breakblock->{$ikey}})
	{
	    print " ",$word;
	    push @{$rev{$word}},$lkey . $pkey;
	}
	print "\n";
    }
}

for $word (sort keys %rev)
{
    next unless scalar @{$rev{$word}} == 1;
    print $word,"(",scalar @{$rev{$word}},"): ",$rev{$word}->[0],"\n";
}

