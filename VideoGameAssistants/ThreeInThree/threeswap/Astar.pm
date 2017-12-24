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
#    state should have a lower grade than the goal, but non-
#    negative
#    a Grade of less than zero represents a state from which
#    the goal CANNOT be reached, and therefore should be pruned.

package Astar;

# The function itself takes two arguments: the inital board state
# object, and whether to print.
# if the arg is 1, it will use the DisplayString and Move methods
# to print the results.
# in either case, it will return undef on fail, and an array
# of BoardStates, 0 being initial, and n being the winning state.


sub Astar($$)
{
  my ($initial,$doprint) = @_;
  my $grade;
  my $whitestates;
  my $closesttogoal;
  my $closesttogoalstate = undef;
  my $finalstate;

  $grade = $initial->Grade();
  goto WIN if $grade >= $initial->WinGrade();
  goto LOSE if $grade < 0;
	
  $whitestates = White->new();

  $whitestates->insert($initial->CanonicalKey(),$initial->Grade(),0);
  $states{$initial->CanonicalKey()} = $initial;
  
  $closesttogoal = 0;
  $closesttogoalstate = undef;

  my $ctr = 0;


  while($whitestates->size() > 0) {
      print "size of white array = ",$whitestates->size(),
            ", num unique states: ",scalar(keys %states),"\n";

      $currec = $whitestates->getLargest();
      $curstate = $currec->{DATA};
      $curdepth = $currec->{DEPTH};

    $curstate = $states{$curstate};

    @children = $curstate->Successors();

    while (@children) {
      $nextstate = shift @children;
      if (!exists($states{$nextstate->CanonicalKey()})) {
	$grade = $nextstate->Grade();
        if ($grade >= $nextstate->WinGrade()) {
          goto WIN;
        } 
        if ($grade > $closesttogoal) {
          $closesttogoal = $nextstate->Grade();
	  $closesttogoalstate = $nextstate;
          print "Another step closer: ",$nextstate->Grade(),"\n";
        }
	if ($grade < 0) {
	  next;
	}

        $states{$nextstate->CanonicalKey()} = $nextstate;
	$whitestates->insert($nextstate->CanonicalKey(),$grade,$curdepth+1);
      }
    }
  }
 LOSE:
  $finalstate = $closesttogoalstate;

  if ($doprint) {
    print "No solution found, returning closest to goal.\n";
  }
  goto BOTH;

 WIN:
  $finalstate = $nextstate;

  if ($doprint) {
    print "Solution found!\n";
  }

 BOTH:
  
  undef @result;

  $cur = $finalstate;

  while(1) {
     unshift @result,$cur;
     last unless $cur->Parent();         
     $cur = $states{$cur->Parent()};
  }
  if ($doprint) {
    print $result[0]->DisplayString();

    for ($i = 1 ; $i < @result ; $i++) {
      print "Move: ",$result[$i]->Move(),"\n";
      print $result[$i]->DisplayString();
    }
  }
  return @result;
}


sub ByGrade { $states{$b}->Grade() <=> $states{$a}->Grade(); }


# this package keeps track of items by some value, and
# knows how many items it has, and what the largest value
# is.

package White;

sub new
{
    my ($class) = @_;
    my $this = {};
    bless $this,$class;
    $this->{ITEMS} = [];
    $this->{NITEMS} = 0;
    return $this;
}

sub insert
{
    my ($this,$item,$value,$depth) = @_;
    
    my $rec = {};
    $rec->{DATA} = $item;
    $rec->{VALUE} = $value;
    $rec->{DEPTH} = $depth;

    $this->{NITEMS}++;
    
    unshift(@{$this->{ITEMS}},$rec);
    @{$this->{ITEMS}} = sort 
    {
	return $b->{VALUE} <=> $a->{VALUE} if $a->{VALUE} != $b->{VALUE};
	return $a->{DEPTH} <=> $b->{DEPTH};
    } @{$this->{ITEMS}};
}

sub size
{
    my ($this) = @_;
    return $this->{NITEMS};
}

sub getLargest
{
    my ($this) = @_;
    my $rec = shift (@{$this->{ITEMS}});
    $this->{NITEMS}--;

    return $rec;
}

    
					       
	    








package OldWhite;

sub new
{
    my ($class) = @_;
    my $this = {};
    bless $this,$class;
    $this->{NITEMS} = 0;
    $this->{LVALUE} = 0;
    $this->{ITEMS} = {};
    return $this;
}

sub insert
{
    my ($this,$item,$value) = @_;
    if ($this->{NITEMS} == 0) {
	$this->{LVALUE} = $value;
    } else {
	$this->{LVALUE} = $value if $value > $this->{LVALUE};
    }
    if (!exists($this->{ITEMS}->{$value})) {
	$this->{ITEMS}->{$value} = [];
    }
    unshift @{$this->{ITEMS}->{$value}},$item;
    $this->{NITEMS}++;
}

sub size
{
    my ($this) = @_;
    return $this->{NITEMS};
}


sub getLargest
{
    my ($this) = @_;

    my $result = shift @{$this->{ITEMS}->{$this->{LVALUE}}};

    $this->{NITEMS}--;
    if (@{$this->{ITEMS}->{$this->{LVALUE}}} == 0 && $this->{NITEMS} > 0) {
	delete $this->{ITEMS}->{$this->{LVALUE}};
	my @vals = sort {$b <=> $a} keys(%{$this->{ITEMS}});
	$this->{LVALUE} = $vals[0];
    }
    return $result;
}

1;




