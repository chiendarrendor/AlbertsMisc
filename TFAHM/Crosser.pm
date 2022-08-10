
# given the following:
# a grid -- linearization of letters to swap with in left-to-right, top-to-bottom reading order
# a 'b-set' -- a (possibly empty) set of cells (upper left is 0) that form a swapping subset
#	separate from the implied a-set. (i.e. a-set letters will never swap with b-set letters)
# a maxbadcount -- a number, 0 or larger, describing the number of unrecognized words allowed for a 
#  grid to still be a solution
#
# will recurse through all permutations of the letters within the sets on the grid, regarding as a
# solution all such permutations where all horizontal and vertical lines form words in the
# external dictionary file.

# currently, only operates on 3 and 4 letter words
package Crosser;
use ChainWords;
use strict;

sub new($$$$) {
	my ($class,$grid,$bset,$maxbadcount) = @_;
	my ($this) = {GRID=>$grid,BSET=>{},MAXBADCOUNT=>$maxbadcount,SOLUTIONS=>{}};
	for my $item (@$bset) { $this->{BSET}->{$item} = 1; }
	bless $this,$class;
	
	if (length($grid) == 9) {
		$this->{WORDLEN} = 3;
	} elsif (length($grid) == 16) {
		$this->{WORDLEN} = 4;
	} else {
		die("Can't process grid of size " . length($grid));
	}
	
	my $fname = "" . $this->{WORDLEN} . "word.txt";
	$this->{DICTIONARY} = ChainWords::makeChain($fname);
	
	$this->{LINES} = [];
	for (my $major = 0 ; $major < $this->{WORDLEN} ; ++$major) {
		my $hline = [];
		my $vline = [];
		for (my $minor = 0 ; $minor < $this->{WORDLEN} ; ++$minor) {
			push @$hline,$major * $this->{WORDLEN} + $minor;
			push @$vline,$major + $minor * $this->{WORDLEN};
		}
		push @{$this->{LINES}},$hline;
		push @{$this->{LINES}},$vline;
	}
	return $this;
}

sub badlines($$) {
	my ($this,$state) = @_;
	my $result = [];
	for my $line (@{$this->{LINES}}) {
		my $string = "";
		for my $item (@$line) {
			$string .= substr($state,$item,1);
		}
		push @$result,$string unless $this->{DICTIONARY}->validate($string);
	}
	return $result;
}



sub checklines($$) {
	my ($this,$state) = @_;
	my $matchcount = 0;
	for my $line (@{$this->{LINES}}) {
		my $string = "";
		for my $item (@$line) {
			$string .= substr($state,$item,1);
		}
		++$matchcount if $this->{DICTIONARY}->validate($string);
	}
	return $matchcount;
}

sub solve($) {
	my ($this) = @_;
	my $basegrid = "?" x length($this->{GRID});
	my $aletters = "";
	my $bletters = "";
	for (my $i = 0 ; $i < length($this->{GRID}) ; ++$i) {
		if (exists $this->{BSET}->{$i}) {
			$bletters .= substr($this->{GRID},$i,1);
		} else {
			$aletters .= substr($this->{GRID},$i,1);
		}
	}
	
	$this->fillrecurse(0,$basegrid,$aletters,$bletters);
		
}

sub prettyprint($$) {
	my ($this,$solution) = @_;
	my $folded = "";
	for (my $i = 0 ; $i < $this->{WORDLEN} ; ++$i) {
		$folded .= substr($solution,$i * $this->{WORDLEN},$this->{WORDLEN}) . "\n";
	}
	return $folded;
}

sub addsolution($$) {
	my ($this,$solution) = @_;	
	$this->{SOLUTIONS}->{$solution} = 1;
}
	
sub fillrecurse($$$$$) {
	my ($this,$index,$grid,$aletters,$bletters) = @_;
	if ($index == length($grid)) {
		$this->addsolution($grid);
		return;
	}
			
	if (exists $this->{BSET}->{$index}) {
		for (my $i = 0 ; $i < length($bletters) ; ++$i) {
			my $newbletter = substr($bletters,$i,1);
			my $nextbletters = $bletters;
			substr($nextbletters,$i,1,"");
			my $nextgrid = $grid;
			substr($nextgrid,$index,1,$newbletter);
			if ($this->checklines($nextgrid) < 2 * $this->{WORDLEN} - $this->{MAXBADCOUNT}) { next; }
			$this->fillrecurse($index+1,$nextgrid,$aletters,$nextbletters);
		}
	} else {
		for (my $i = 0 ; $i < length($aletters) ; ++$i) {
			my $newaletter = substr($aletters,$i,1);
			my $nextaletters = $aletters;
			substr($nextaletters,$i,1,"");
			my $nextgrid = $grid;
			substr($nextgrid,$index,1,$newaletter);
			if ($this->checklines($nextgrid) < 2 * $this->{WORDLEN} - $this->{MAXBADCOUNT}) { next; }
			$this->fillrecurse($index+1,$nextgrid,$nextaletters,$bletters);
		}
	}
}



1;

	
	
	
	