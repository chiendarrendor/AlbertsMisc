# takes:
#   a board as described in threesome.pl
#   a functor (object blessed into some package that implements function:
#       $functor->RoomVisited($thisroom,$sourceroom,$depth)
#       if this function returns undef, that will cause an immediate return
#   a list of starting room names in board.
# returns:
#   undef on error
#   1 on normal return
#   2 if functor caused exit

use ShowDataStructure;



package boardBFS;

sub doBFS
{
    my ($board,$functor,@startingpoints) = @_;

    my $roomkey;
    my @whitelist; # contains room,parent pairs
    my %blacklist;

    foreach $roomkey (@startingpoints)
    {
	if (!exists $board->{ROOMS}->{$roomkey})
	{
	    print "Unknown room $roomkey in doBFS\n";
	    return undef;
	}

	push(@whitelist,[$roomkey,undef]);
    }

    while(@whitelist != 0)
    {
	my $whiteentry = shift(@whitelist);
	my $visitroom = $whiteentry->[0];
	my $sourceroom = $whiteentry->[1];

	# if we've already visited here, don't do it again.
	next if exists($blacklist{$visitroom});

	# mark it as visited (blacklist is also depth)
	if ($sourceroom)
	{
	    $blacklist{$visitroom} = $blacklist{$sourceroom} + 1;
	}
	else
	{
	    $blacklist{$visitroom} = 0;
	}
	
	# inform the functor that the room was visited.
	if (!$functor->RoomVisited($visitroom,$sourceroom,$blacklist{$visitroom}))
	{
	    return 2;
	}

	# push all rooms accessable through doors onto whitelist.
	my $door;
	
	foreach $door (@{$board->{ROOMS}->{$visitroom}->{DOORS}})
	{
	    push(@whitelist,[$door->{DESTROOM},$visitroom]);
	}
    }

    return 1;
}

	    
	    
1;
