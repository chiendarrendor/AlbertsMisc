use Board;

package BoardBFS;

my @queue;
my %seen;
my $best;

sub Enqueue
{
    my ($board) = @_;
    return if exists($seen{$board->CanonicalKey()});
    $seen{$board->CanonicalKey()} = 1;

    $board->FindBestMatches();

    if (!$best)
    {
	print "First Best: ",$board->{GRADE},"\n";
	$best = $board;
    }
    elsif ($best->{GRADE} < $board->{GRADE})
    {
	print "New Best: ",$board->{GRADE},"\n";
	$best = $board;
    }

#    print "Enqueue: ",scalar keys %seen,"\n";

    push @queue,$board;
}

sub Dequeue
{

    if (@queue > 0)
    {
	my $cur = shift @queue;
#	print "Dequeue: ",$cur->{DEPTH},"\n";

	if ($cur->{DEPTH} > 1)
	{
	    return undef;
	}
	return $cur;
    }
    return undef;
}

sub BoardBFS
{
    my ($board) = @_;
    my $loopcount = 0;

    undef @queue;
    undef %seen;
    $best = undef;

    Enqueue($board);

    my $cur;

    while($cur = Dequeue())
    {
	if (($loopcount++ % 100) == 0)
	{
	    print "Q: ",scalar @queue;
	    print " S: ",scalar keys %seen;
	    print " D: ",$cur->{DEPTH};
	    print "\n";
	}

	my @successors = $cur->Successors();

	my $succ;
	foreach $succ (@successors)
	{
	    Enqueue($succ);
	}
    }
}

    
1;
