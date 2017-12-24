


my $sheads;
my $curheads;
my $chopheads;

for ($sheads = 2 ; $sheads < 41 ; ++ $sheads)
{
    $curheads = $sheads;
    print "Start $sheads: ";

    while($curheads < 41)
    {
	$chopheads = $curheads - 1;
	$curheads = 1 + 2 * $chopheads;
	print $curheads, " ";
    }

    if ($curheads == 41)
    {
	print "found it!\n";
	exit(1);
    }
    else
    {
	print "\n";
    }
}

	

