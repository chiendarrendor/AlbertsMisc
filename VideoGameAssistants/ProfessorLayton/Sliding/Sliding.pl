BEGIN { push @INC,"../../Common/Perl"; }

use Astar;

package Slider;

# Axx.
# BBCD
# EFFG
# EFFG
# HIJJ
# .xx.  <- goal: get A here

# stored: Axx./BBCD/EFFG/EFFG/HIJJ/.xx.

sub new
{
    my ($class) = @_;
    my $this = {};
    bless $this,$class;
    $this->{KEY} = "Axx./BBCD/EFFG/EFFG/HIJJ/.xx.";
    $this->{DEPTH} = 0;
    return $this;
}

sub CanonicalKey 
{
    my ($this) = @_;
    return $this->{KEY};
}

sub At
{
    my ($this,$x,$y) = @_;
    return substr($this->{KEY},$y*5+$x,1);
}

sub InDir
{
    my ($this,$x,$y,$dir) = @_;
    return ($x+1,$y) if $dir eq 'R';
    return ($x-1,$y) if $dir eq 'L';
    return ($x,$y-1) if $dir eq 'U';
    return ($x,$y+1) if $dir eq 'D';
}

sub InBounds
{
    my ($this,$x,$y) = @_;
    return 0 if $x < 0 || $x >= 4;
    return 0 if $y < 0 || $y >= 6;
    return 1;
}

# determines if the given piece has
# open space in the given direction
# if so, execute the move on KEY and return 1
# otherwise, return 0
sub DoMove
{
    my ($this,$piece,$dir) = @_;
    for (my $x = 0 ; $x < 4 ; ++$x) {
	for (my $y = 0 ; $y < 6 ; ++$y) {
	    next unless $this->At($x,$y) eq $piece;
	    ($nx,$ny) = $this->InDir($x,$y,$dir);
	    return 0 unless $this->InBounds($nx,$ny);
	    return 0 unless $this->At($nx,$ny) eq '.' ||
		$this->At($nx,$ny) eq $piece;
	}
    }
    # if we get here, then the piece in question is mobile along
    # one side.  let's move it!
    my $newkey = $this->{KEY};

    for (my $x = 0 ; $x < 4 ; ++$x) {
	for (my $y = 0 ; $y < 6 ; ++$y) {
	    next unless $this->At($x,$y) eq $piece;
	    substr($newkey,$y*5+$x,1) = '.';
	}
    }
    for (my $x = 0 ; $x < 4 ; ++$x) {
	for (my $y = 0 ; $y < 6 ; ++$y) {
	    next unless $this->At($x,$y) eq $piece;
	    ($nx,$ny) = $this->InDir($x,$y,$dir);
	    substr($newkey,$ny*5+$nx,1) = $piece;
	}
    }
    $this->{KEY} = $newkey;
    return true;
}


sub Successors
{
    my ($this) = @_;
    my @result;
    
    for my $p ('A','B','C','D','E','F','G','H','I','J') {
	for my $d ('U','D','L','R') {
	    my $nst = new Slider();
	    $nst->{KEY} = $this->{KEY};
	    $nst->{PARENT} = $this->CanonicalKey();
	    $nst->{MOVE} = $p . $d;
	    $nst->{DEPTH} = $this->{DEPTH} + 1;
	    next unless $nst->DoMove($p,$d);
	    push @result, $nst;
	}
    }
    return @result;
}

sub WinGrade
{
    return 8;
}


sub Grade
{
    my ($this) = @_;
    for (my $x = 0 ; $x < 4 ; ++$x) {
	for (my $y = 0 ; $y < 6 ; ++$y) {
	    next unless $this->At($x,$y) eq 'A';
	    return $x + $y;
	}
    }
}

sub DisplayString
{
    my ($this) = @_;
    return join("\n",split("/",$this->{KEY})),"\n";
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

package main;

#$s = new Slider();
#print $s->DisplayString();

#print "----\n";

#@succs = $s->Successors();
#for $ss (@succs) {
#    print $ss->DisplayString();
#    print $ss->Move(),"\n";
#    print "\n";
#}

    


Astar::Astar(new Slider(),1);
