# fi ap ch fi
# ap sp sp ap
# sp fi fi ch
# ch ch ap sp

# 1. top down through same as top all move at once
# 2. stack no higher than 6
# 3. goal: each stack only having one good

use lib "C:/msys/1.0/home/Chien/Common/Perl";
use Astar;

package Board;

sub new
{
    my ($class) = @_;
    my $this = {};
    bless $this,$class;

    $this->{DEPTH} = 0;
    # leftmost is top
    $this->{STACKS}->[0] = [ "  ","  ","fi","ap","sp","ch"];
    $this->{STACKS}->[1] = [ "  ","  ","ap","sp","fi","ch"];
    $this->{STACKS}->[2] = [ "  ","  ","ch","sp","fi","ap"];
    $this->{STACKS}->[3] = [ "  ","  ","fi","ap","ch","sp"];

    return $this;
}

sub DisplayString
{
    my ($this) = @_;
    my $result;
    for (my $i = 0 ; $i < 6 ; ++$i)
    {
	$result .= "| ";
	for (my $j = 0 ; $j < 4 ; ++$j)
	{
	    $result .= $this->{STACKS}->[$j]->[$i] . " ";
	}
	$result .= "|\n";
    }
    return $result;
}

# if we get here, we know that we have at least one more move
# we are provided source and dest columns
# we do not know if there is enough room
# on top of dest for all of source's stuff
# return undef if that's true.

sub Successor
{
    my ($this,$source,$dest) = @_;
    # find out # and identity of top item on source
    my $sourceempty = 0;
    my $top = "  ";
    my $topcount = 0;
    for (my $i = 0 ; $i < 6 ; ++$i)
    {
	if ($this->{STACKS}->[$source]->[$i] eq "  ")
	{
	    ++$sourceempty;
	    next;
	}
	       
	if ($top eq "  ")
	{
	    $top = $this->{STACKS}->[$source]->[$i];
	    ++$topcount;
	} 
	elsif ($top eq $this->{STACKS}->[$source]->[$i])
	{
	    ++$topcount;
	}
	else
	{
	    last;
	}
    }

#    print "top: $top\n";
#    print "topcount: $topcount\n";
#    print "sourceempty: $sourceempty\n";

    # find out # of empty spaces on dest
    my $destempty = 0;
    for (my $i = 0 ; $i < 6 ; ++$i)
    {
	if ($this->{STACKS}->[$dest]->[$i] eq "  ")
	{
	    ++$destempty;
	}
	else
	{
	    last;
	}
    }

#    print "destempty: $destempty\n";

    return undef if ($topcount > $destempty);
    
    my $newboard = new Board();
    $newboard->{DEPTH} = $this->{DEPTH} + 1;
    $newboard->{PARENT} = $this->CanonicalKey;
    $newboard->{MOVE} = "$source to $dest";
    for ($i = 0 ; $i < 4 ; ++$i)
    {
	for ($j = 0 ; $j < 6 ; ++$j)
	{
	    $newboard->{STACKS}->[$i]->[$j] = $this->{STACKS}->[$i]->[$j]; 
	}
    }

    # now fix the new board
    for ($i = 0 ; $i < $sourceempty + $topcount ; ++$i)
    {
	$newboard->{STACKS}->[$source]->[$i] = "  ";
    }

    for ($i = 0 ; $i < $topcount ; ++$i)
    {
	$newboard->{STACKS}->[$dest]->[$i+$destempty-$topcount] = $top;
    }

    return $newboard;
}	

sub Move
{
    my ($this) = @_;
    return $this->{MOVE};
}

sub Parent
{
    my ($this) = @_;
    return $this->{PARENT};
}

sub Depth
{
    my ($this) = @_;
    return $this->{DEPTH};
}


sub Successors
{
    my ($this) = @_;
    my @result;

    return @result if ($this->{DEPTH} == 14);

    for (my $source = 0 ; $source < 4 ; ++$source)
    {
	for (my $dest = 0 ; $dest < 4 ; ++$dest)
	{
	    next if $source == $dest;

	    $succ = $this->Successor($source,$dest);
	    push @result,$succ if (defined $succ);
	}
    }

    return @result;
}

sub CanonicalKey
{
    my ($this) = @_;
    my $result = "";
    for (my $i = 0 ; $i < 4 ; ++$i)
    {
	for (my $j = 0 ; $j < 6 ; ++$j)
	{
	    $result .= $this->{STACKS}->[$i]->[$j];
	}
    }
    return $result;
}

sub WinGrade
{
    return 12;
}

sub Grade
{
    my ($this) = @_;
    my $ctr = 0;
    for (my $i = 0 ; $i < 4 ; ++$i)
    {
	for (my $j = 0 ; $j < 5 ; ++$j)
	{
	    next if $this->{STACKS}->[$i]->[$j] eq "  ";
	    ++$ctr if 
		$this->{STACKS}->[$i]->[$j] eq
		$this->{STACKS}->[$i]->[$j+1];
	}
    }
    return $ctr;
}

		

package main;

$b = new Board();
$| = 1;

Astar::Astar($b,1);	    
exit(1);

$b->{STACKS}->[0] = [ "  ","  ","ap","ap","ap","ap"];
$b->{STACKS}->[1] = [ "  ","  ","ch","ch","ch","ch"];
$b->{STACKS}->[2] = [ "  ","  ","fi","fi","fi","fi"];
$b->{STACKS}->[3] = [ "  ","  ","sp","sp","sp","sp"];

print "Grade: ",$b->Grade(),"\n";
exit(1);

$nb = $b->Successor(1,3);

print "old:\n";
print $b->DisplayString();

print "new:\n";
if (defined $nb)
{
    print $nb->DisplayString();
}
else
{
    print "empty\n";
}

