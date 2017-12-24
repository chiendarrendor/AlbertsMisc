
@words = (abc,osa,rlh,fcb,luo,rra,dyn);
@inds;
for (my $i = 0 ; $i < @words ; ++$i) { $inds[$i] = 0; }

while(1)
{
    for (my $i = 0 ; $i < @words ; ++$i) 
    { 
	print substr($words[$i],$inds[$i],1);
    }
    print "\n";

    my $chi = 0;
    while($chi < @words)
    {
	++$inds[$chi];
	if ($inds[$chi] == length($words[$chi]))
	{
	    $inds[$chi] = 0;
	}
	else
	{
	    last;
	}
	++$chi;
    }
    last if ($chi == @words);
}

	
