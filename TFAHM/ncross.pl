#! /c/Perl64/bin/perl.exe

use Crosser;
use strict;

if (@ARGV == 0) {
	print "Bad Command Line [-b maxbad] 'STRING' [b-cells (start with 0)]\n";
	exit 1;
}

my $maxbad = 0;
if ($ARGV[0] eq '-b') {
	if (@ARGV < 2) {
		print "Bad command line...\n";
		exit 1;
	}
	$maxbad = $ARGV[1];
	shift;
	shift;
} 

my $grid="";
if (@ARGV == 0) {
	print "bad command line.\n";
	exit 1;
}
$grid = $ARGV[0];
shift;


my $crosser = new Crosser($grid,\@ARGV,$maxbad);
$crosser->solve();

for my $solution (keys %{$crosser->{SOLUTIONS}}) {
	print "----\n";
	print $crosser->prettyprint($solution);
	print "\n";
	print join(" ",@{$crosser->badlines($solution)}),"\n";
}
