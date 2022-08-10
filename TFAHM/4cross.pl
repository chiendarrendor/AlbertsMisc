#! /c/Perl64/bin/perl.exe

use ChainWords;

my $wordfile = "4word.txt";
my $chain = ChainWords::makeChain($wordfile);



#  0  1  2  3
#  4  5  6  7
#  8  9 10 11
# 12 13 14 15

# lines: 

my @lines = (
 [0, 1, 2, 3],
 [4, 5, 6, 7],
 [8, 9, 10, 11],
 [12, 13, 14, 15],
 [0, 4, 8, 12],
 [1, 5, 9, 13],
 [2, 6, 10, 14],
 [3, 7, 11, 15]	
);

my %bnums;
my $maxbadcount = 0;

 
my %solutions;




# perl 4cross.pl "RKGNSAAUTAWPAMEN" 9 10 13 14
if (@ARGV != 5) {
	print "bad command line: <16 letters> <b-set 1> <b-set 2> <b-set 3> <b-set 4>\n";
	exit(1);
}


if ($ARGV[0] !~ /^[A-Z]{16}$/) {
	print "bad command line: first arg must be 16 LETTERS.\n";
	exit(1);
}


for (my $i = 1 ; $i < 5 ; ++$i) {
	if ($ARGV[$i] !~ /^\d+$/) {
		print "bad command line: $i arg must be numeric\n";
		exit(1);
	}
	if ($ARGV[$i] >= 16) {
		print "bad command line: $i arg must refer to a valid cell\n";
		exit(1);
	}
	$bnums{$ARGV[$i]} = 1;
}

my $rawletters = $ARGV[0];
my $grid = "";
my $aletters = "";
my $bletters = "";

for (my $i = 0 ; $i < 16 ; ++$i) {
	$grid .= "?";
	if (exists $bnums{$i}) {
		$bletters .= substr($rawletters,$i,1);
	} else {
		$aletters .= substr($rawletters,$i,1);
	}
}


fillrecurse(0,$grid,$aletters,$bletters,0);

print "# of Solutions found: ",scalar(keys %solutions),"\n";
for my $solution (keys %solutions) {
	print "-------------\n";
	for (my $i = 0 ; $i < 4 ; ++$i) {
		print substr($solution,4*$i,4),"\n";
	}
}



