#!/usr/bin/perl
# parse language described in Newick.output
# Perl source code automatically generated at Wed Nov 28 01:18:37 2012 by
# py v.0.1 25 Aug 1995
# Source code copyright 1995 M-J. Dominus (mjd@pobox.com)
#

require 'py-skel.pl';
require 'Newick-rules.pl';

$; = "\034";
%act = (
"0Branch",	'goto 5',
"0Internal",	'goto 4',
"0\$default",	'reduce 9',
"0Name",	'goto 8',
"0string",	'shift 1',
"0Leaf",	'goto 7',
"0(",	'shift 2',
"0Tree",	'goto 3',
"0Subtree",	'goto 6',
"1\$default",	'reduce 10',
"2(",	'shift 2',
"2Leaf",	'goto 7',
"2Name",	'goto 8',
"2Internal",	'goto 4',
"2\$default",	'reduce 9',
"2Subtree",	'goto 6',
"2string",	'shift 1',
"2BranchSet",	'goto 10',
"2Branch",	'goto 9',
"3\$end",	'shift 11',
"4\$default",	'reduce 7',
"5;",	'shift 12',
"6\$default",	'reduce 4',
"6:",	'shift 13',
"6Length",	'goto 14',
"7\$default",	'reduce 6',
"8\$default",	'reduce 8',
"9\$default",	'reduce 11',
"10)",	'shift 15',
"10,",	'shift 16',
"11\$default",	'accept',
"12\$default",	'reduce 1',
"13number",	'shift 17',
"14\$default",	'reduce 3',
"15\$default",	'reduce 9',
"15string",	'shift 1',
"15Name",	'goto 18',
"16Branch",	'goto 19',
"16\$default",	'reduce 9',
"16Name",	'goto 8',
"16string",	'shift 1',
"16Internal",	'goto 4',
"16Leaf",	'goto 7',
"16Subtree",	'goto 6',
"16(",	'shift 2',
"17\$default",	'reduce 5',
"18\$default",	'reduce 2',
"19\$default",	'reduce 12',
);

@length = ();

@rhs = ();

@rule = (
);

