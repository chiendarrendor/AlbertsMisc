#
# given a grid like this:
# aAab
# eEee
# lrIr
# svLy
# 
# (presented as aAab eEee lrIr svLy on the command line)
# find all grids where all horizontal and vertical lines are
# real 4-letter words, allowing the exchange of letters
# of the same capitalization.
# (the capitalization is only to divide the grid into two sets,
#  where any given letter may only be swapped between the cells of one set or
#  the other; otherwise, all words should be all lower-case letters)
# output: (others may be possible)
# beer
# rave
# asia
# yell

use GridData;
use Utility;
use QueueItem;

die("bad command line") unless @ARGV == 4;
my $gd = new GridData(@ARGV);

# processing
# make a queue of states
# initial states are all permutations of the upper case letters
# (all games seen so far have only 4 of one of the two sets)
my @queue;
my @results;
my $initials = Utility::PermuteArray($gd->{UPPERCHARS});
for(my $i = 0 ; $i < @$initials ; ++$i)
{
    my $ni = newFromUpper QueueItem($gd,$initials->[$i],$gd->{UPPERCELLS});
    next unless $ni->Validate();
    push @queue,$ni;
}


#$item = newFromUpper QueueItem($gd,['l','e','a','i'],$gd->{UPPERCELLS});
#$item->AddWord(4,"slab");
#$item->AddWord(5,"eely");
#$item->AddWord(6,"rear");
#$item->AddWord(7,"avie");

#$item->PrintGrid();
#print "Opens: ",join(",",@{$item->{OPENLINES}}),"\n";

#print "Validated: (",$item->Validate(),")\n";
#exit(1);

# while queue is not empty
QUEUE: while(@queue > 0)
{
    my $workitem = shift @queue;

    # if item is full, it is a good result.
    if ($workitem->IsFull())
    {
	push @results,$workitem;
	next;
    }
    # find the smallest list of words that can go in each open line
    # (a zero-sized line means this is an invalid item)
    my $minsize = 1000000;
    my $minlineid;
    my $minwords;
    for my $line (@{$workitem->{OPENLINES}})
    {
	my $lineword = $gd->SearchWords($workitem->GetWord($line),$workitem->{UNUSED});
	next QUEUE if @$lineword == 0;
	if (@$lineword < $minsize)
	{
	    $minsize = @$lineword;
	    $minlineid = $line;
	    $minwords = $lineword;
	}
    }

    if ($minsize == 1)
    {
	$workitem->AddWord($minlineid,$minwords->[0]);
	next unless $workitem->Validate();
	push @queue,$workitem;
    }
    # if we get here, there was more than one word.
    for my $word (@$minwords)
    {
	my $newitem = $workitem->clone();
	$newitem->AddWord($minlineid,$word);
	next unless $newitem->Validate();
	push @queue,$newitem;
    }
}

for my $item (@results)
{
    print "------\n";
    $item->PrintGrid();
}

	
print "grid count: ", QueueItem::GetCount(),"\n";
