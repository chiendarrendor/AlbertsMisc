
sub PrintPatterns
{
    my ($pats) = @_;
    foreach $patkey (keys %{$pats->{PATTERNS}})
    {
	$pat = $pats->{PATTERNS}->{$patkey};
	
	print "Pattern: $patkey ";
	print "W: ",$pat->GetWidth()," H:",$pat->GetHeight()," G:",$pat->GetGrade(),"\n";
	for ($i = 0 ; $i < $pat->GetHeight() ; ++$i)
	{
	    print "  ";
	    for ($j = 0 ; $j < $pat->GetWidth() ; ++$j)
	    {
		print $pat->GetCell($j,$i);
	    }
	    print "\n";
	}
    }
}

sub Show2Board
{
    my ($board1,$board2) = @_;
    my $i;
    my $j;

    print "CMP: ";
    if ($board1->CanonicalKey() eq $board2->CanonicalKey())
    {
	print "EQ ";
    }
    else
    {
	print "NE ";
    }

    print $board2->{MOVE},"\n";

    for ($j = 0 ; $j < 5 ; ++$j)
    {
	for($i = 0 ; $i < 5 ; ++$i)
	{
	    my $c1 = $board1->GetCell($i,$j);
	    $c1 =~ y/A-Z/a-z/ if $c1 ne $board2->GetCell($i,$j);

	    print $c1;
	}
	print " ";
	for($i = 0 ; $i < 5 ; ++$i)
	{
	    my $c2 = $board2->GetCell($i,$j);
	    $c2 =~ y/A-Z/a-z/ if $c2 ne $board1->GetCell($i,$j);

	    print $c2;
	}
	print "\n";
    }
}

sub ShowMatch
{
    my ($board,$match) = @_;
    my $matx = $match->{X};
    my $maty = $match->{Y};
    my $matp = $match->{PATTERN};

    my $i;
    my $j;

    print "Match to Pattern ",$matp->GetName(),":\n";
    
    for ($j = 0 ; $j < 5 ; ++$j)
    {
	for($i = 0 ; $i < 5 ; ++$i)
	{
	    my $bcell = $board->GetCell($i,$j);

	    if ($i >= $matx && $i < $matx + $matp->GetWidth() &&
		$j >= $maty && $j < $maty + $matp->GetHeight())
	    {
		my $pcell = $matp->GetCell($i-$matx,$j-$maty);
		die("oops\n") if $pcell ne '.' && $pcell ne $bcell;
		$bcell =~ y/A-Z/a-z/ if $pcell ne '.';
	    }
	    
	    print $bcell;
	}
	print "\n";
    }
}

1;
