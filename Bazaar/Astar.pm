# this library embodies the A* algorithm
# To use, put
# use "Astar";
# in your code.  Your code should define
# a package/class that
# defines the following methods:
# $class->CanonicalKey() -- given a $class
#    item, return a key for that state that 
#    1. will uniquely identify that state, and
#    2. if two different representations of 
#       the same board are considered identical,
#       the key for those two representations
#       will also be identical.
#       (for example, on a chess board, since
#        all pawns are identical, all permutations
#        of the pawns in the same squares should
#        have the same CanonicalKey.)
#  $class->Successors() -- This routine will
#    return a list of all possible successors
#    to that state.  It is not necessary to cull
#    duplicates, the algorithm will do that efficiently
#  $class->DisplayString() -- This routine will return
#    a string representing a visual display of the board.
#  $class->Move() -- This routine will return
#    a string representing how we got here from the parent.
#    (data this represents should be set internally during Successors)
#  $class->Parent() -- This routine will return the
#    Canonical Key of our parent state (this also needs to be
#    set internally during Successors)
#  $class::WinGrade() -- This class method will return the
#    number representing the grade of a state at the goal.
#  $class->Grade() -- This routine will return a number
#    representing how close to the goal this particular state is.
#    It should only be = to WinGrade iff this grade is a win.
#    The grade should be largest at the goal; any non-goal
#    state should have a lower grade than the goal.

package Astar;

# The function itself takes two arguments: the inital board state
# object, and whether to print.
# if the arg is 1, it will use the DisplayString and Move methods
# to print the results.
# in either case, it will return undef on fail, and an array
# of BoardStates, 0 being initial, and n being the winning state.


sub ByGrade 
{ 
    $b->{GRADE} <=> $a->{GRADE};
}

sub ValidateWhiteStates
{
    my ($wsref) = @_;
    my @grid;
    my $curnum;
    my $curcount;
    my $i;
    my $curg;

    undef @grid;
	
    $curnum = $$wsref[0]->{GRADE};
    $curcount = 0;
    for ($i = 0 ; $i < @$wsref ; $i++)
    {
	$curg = $$wsref[$i]->{GRADE};
	if ($curnum == $curg)
	{
	    $curcount++;
	}
	else
	{
	    push @grid,$curcount . " of " . $curnum;
	    $curcount = 1;
	    $curnum = $curg;
	}
    }
    push @grid,$curcount . " of " . $curnum;
    
    print join(",",@grid),"\n";
}



sub Astar($$)
{
    my ($initial,$doprint) = @_;
	
    my $wsEnt;
    my %states;
    my @whitestates;
    my $nextstate;
    my @result;

    if ($initial->Grade() >= $initial->WinGrade())
    {
	$nextstate = $initial;
	goto WIN;
    }

    $wsEnt = {};
    $wsEnt->{KEY} = $initial->CanonicalKey();
    $wsEnt->{GRADE} = $initial->Grade();


    $whitestates[0] = $wsEnt;
    $states{$initial->CanonicalKey()} = $initial;
    $nstates = 1;
  
    $closesttogoal = 0;

    my $nextprint = 1000;


    while(@whitestates) 
    {
	@whitestates = sort ByGrade @whitestates;

	#ValidateWhiteStates(\@whitestates);
	    
	$curwhiteEnt = shift @whitestates;
	$curwhiteKey = $curwhiteEnt->{KEY};
	$curstate = $states{$curwhiteKey};

#	if ($nstates > $nextprint)
#	{
#	    print "WS: ",scalar @whitestates," S: ",$nstates," ";
#	    ValidateWhiteStates(\@whitestates);
#	    $nextprint += 1000;
#	}

	@children = $curstate->Successors();
	
	while (@children) {
	    $nextstate = shift @children;

	    $nextkey = $nextstate->CanonicalKey();

	    if (exists($states{$nextkey}))
	    {
		next;
	    }

	    $nextgrade = $nextstate->Grade();
	    
	    if ($nextgrade >= $nextstate->WinGrade()) {
		goto WIN;
	    } 

	    if ($nextgrade > $closesttogoal) {
		$closesttogoal = $nextgrade;
#		print "Another step closer: ",$nextgrade,"\n";
#		print $nextstate->DisplayString();
	    }
      
	    $wsEnt = {};
	    $wsEnt->{KEY} = $nextkey;
	    $wsEnt->{GRADE} = $nextgrade;

	    $states{$nextkey} = $nextstate;
	    $nstates++;
	    push @whitestates,$wsEnt;
	}
    }
    if ($doprint) {
	print "No solution found!\n";
    }
    return @result;

  WIN:

    $cur = $nextstate;
    
    while(1) {
	unshift @result,$cur;
	last unless $cur->Parent();         
	$cur = $states{$cur->Parent()};
    }
    if ($doprint) {
	print "Solution Found:\n";
    
	print $result[0]->DisplayString();
	
	for ($i = 1 ; $i < @result ; $i++) {
	    print "Move: ",$result[$i]->Move(),"\n";
	    print $result[$i]->DisplayString();
	}
    }
    return @result;
}




1;


