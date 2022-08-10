#! /c/Perl64/bin/perl.exe

if (@ARGV != 1) {
	print "Bad Command Line\n";
	exit 1;
}

my $string = $ARGV[0];

while(1) {
	print $string,"\n";
	my $pair = <STDIN>;
	chomp $pair;
	if (length($pair) != 2) { 
		print "need two letters\n";
		next;
	}
	if (index($string,substr($pair,0,1)) == -1 || index($string,substr($pair,1,1)) == -1) {
		print "can't\n";
		next;
	}
	
	my $rev = reverse($pair);
	print "PR: $pair $rev\n";
	eval "\$string =~ tr/$pair/$rev/";
	
}
