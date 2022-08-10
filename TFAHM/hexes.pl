#! /c/Perl64/bin/perl.exe

use strict;
use integer;

my $WIDTH = 8;
my $HEIGHT = 4;
my $WORDLEN = 4;
my $WORDCOUNT = 8;

my %dictionary;
my %excludes;
sub loaddictionary() {
	open(my $fd,"<","collinswords2019.txt");
	while(<$fd>) {
		chomp;
		next unless length($_) == $WORDLEN;
		$dictionary{$_} = 1;
	}
}
	
sub readfile($) {
	my ($fname) = @_;
	open(my $fd,"<",$fname) || die("no such file as $fname\n");
	my $result = [];
	while(<$fd>) {
		chomp;
		next if length($_) == 0;
		if (length($_) == $WIDTH) {
			push @$result,$_;
			next;
		}
		if (length($_) == $WORDLEN) {
			$excludes{$_} = 1;
			next;
		}
		die("Bad line length: $_\n");
	}
	die("Bad # of lines\n") unless scalar @$result == $HEIGHT;
	return $result;
}

sub indexof($$) {
	my ($x,$y) = @_;
	return $y * $WIDTH + $x;
}

sub wordarstring($) {
	my ($wordar) = @_;
	my $result = "[ ";
	for (my $i = 0 ; $i < $WORDLEN ; ++$i) { $result .= $wordar->[$i] . " "; }
	$result .= "]";
	return $result;
}


sub makeword($$) {
	my ($letters,$curword) = @_;
	my $result = "";
	for (my $i = 0 ; $i < $WORDLEN ; ++$i) {
		my $curi = $curword->[$i];
		my $y = $curi / $WIDTH;
		my $x = $curi % $WIDTH;
		$result .= substr($letters->[$y],$x,1);
	}
	return $result;
}

sub isword($$) {
	my ($letters,$curword) = @_;
	my $word = makeword($letters,$curword);
	return exists $dictionary{$word} && !exists $excludes{$word};
}

sub onboard($) {
	my ($cref) = @_;
	return $cref->{X} >= 0 && $cref->{Y} >= 0 && $cref->{X} < $WIDTH && $cref->{Y} < $HEIGHT;
}


sub adjacents($$) {
	my ($x,$y) = @_;
	my $result = [];
	
	# NW
	my $cell = {X=>$x-1,Y=>$y-1};
	push @$result,$cell if onboard($cell);
	
	# NE
	$cell = {X=>$x,Y=>$y-1};
	push @$result,$cell if onboard($cell);
	
	# W
	$cell = {X=>$x-1,Y=>$y};
	push @$result,$cell if onboard($cell);
	
	# E
	$cell = {X=>$x+1,Y=>$y};
	push @$result,$cell if onboard($cell);
	
	# SW
	$cell = {X=>$x,Y=>$y+1};
	push @$result,$cell if onboard($cell);
	
	# SE
	$cell = {X=>$x+1,Y=>$y+1};
	push @$result,$cell if onboard($cell);
	
	return $result;
}
	
sub contains($$) {
	my ($arref,$ent) = @_;
	for (my $i = 0 ; $i < @$arref ; ++$i) {
		return 1 if ($arref->[$i] == $ent);
	}
	return 0;
}
	
sub recursewords($$$$$) {
	my ($letters,$goodwords,$curword,$x,$y) = @_;
	if (scalar @$curword == $WORDLEN) {	
		push @$goodwords,$curword if isword($letters,$curword);
		return;
	}
	
	my $adjacents = adjacents($x,$y);
	for my $adjacent (@$adjacents) {
	
		my $newword = [];
		for my $idx (@$curword) { push @$newword,$idx; }
		my $newent = indexof($adjacent->{X},$adjacent->{Y});
		next if contains($newword,$newent);

		push @$newword,$newent;
		recursewords($letters,$goodwords,$newword,$adjacent->{X},$adjacent->{Y});
	}
}
		



# returns a list of lists of four indices (top row is 0-7, next row is 8-15, etc)
# that represent valid 4-letter words in the grid, where grid connectivity is hex-based
# (see the game for connectivity)
sub getwords($) {
	my ($letters) = @_;
	my $result = [];
	for (my $y = 0 ; $y < $HEIGHT ; ++$y) {
		for (my $x = 0 ; $x < $WIDTH ; ++$x) {
			recursewords($letters,$result,[indexof($x,$y)],$x,$y);
		}
	}
	return $result;
}

sub cellsused($$) {
	my ($masterlist,$newword) = @_;
	for my $index (@$newword) {
		return 1 if exists $masterlist->{$index};
	}
	return 0;
}
			
sub process($$$$$$) {
	my ($grid,$wordlist,$curindex,$usedwords,$usedcells,$curwords) = @_;
	if (@$curwords == $WORDCOUNT) {
		for (my $i = 0 ; $i < $WORDCOUNT ; ++$i ) {
			my $wordar = $wordlist->[$curwords->[$i]];
			my $word = makeword($grid,$wordar);
			print wordarstring($wordar),$word," ";
		}
		print "\n";
		return;
	}
	
	for(my $i = $curindex ; $i < @$wordlist ; ++$i) {
		my $wordar = $wordlist->[$i];
		my $word = makeword($grid,$wordar);
		next if exists $usedwords->{$word};
		next if cellsused($usedcells,$wordar);
		
		$usedwords->{$word} = 1;
		for my $index (@$wordar) { $usedcells->{$index} = 1; }
		push @$curwords,$i;
		
		process($grid,$wordlist,$i+1,$usedwords,$usedcells,$curwords);
		
		pop @$curwords;
		delete $usedwords->{$word};
		for my $index (@$wordar) { delete $usedcells->{$index}; }
	}
}



die("Bad Command Line") if @ARGV == 0;
loaddictionary();
my $file = readfile($ARGV[0]);
my $words = getwords($file);
my %foundwords;
my %exemplar;

# putting 'go' (or anything else on command line, will
# do processing...otherwise we want word report.
if (@ARGV == 1) {
	print "Word Report:\n";
	for my $word (@$words) {
		my $wordstr = makeword($file,$word);
		++$foundwords{$wordstr};
		$exemplar{$wordstr} = $word;
		
	}
	for my $word (keys %foundwords) {
		print $word,":  ",$foundwords{$word},"\t",wordarstring($exemplar{$word}),"\n";
	}
	print "Total: ",scalar @$words,"\n";
	
	exit(0);
}

process($file,$words,0,{},{},[]);


