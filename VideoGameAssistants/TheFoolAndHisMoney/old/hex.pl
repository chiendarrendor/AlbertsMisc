@w4 = split("\n",`grep -E '^.{4}\$' wordsEn.txt`);
for $w (@w4) { $w4{$w} = 1; }

delete $w4{quae};
delete $w4{abbe};
delete $w4{bubo};
delete $w4{quia};
delete $w4{quai};
delete $w4{quat};
delete $w4{tabu};
delete $w4{butt};
delete $w4{babu};
delete $w4{tate};
delete $w4{babe};
delete $w4{baba};
$w4{ziti} = 1;

@war = 
(
 "quito...",
 "uaaabut.",
 ".aebbz..",
 "...buz.."
);



@war = 
(
 ".uito...",
 "..aabut.",
 "..ebbz..",
 "...buz.."
);

@dirs = 
(
    [ 1,0  ], # >
    [ 1,1  ], # >V
    [ 0,1  ], # <V
    [ -1,0 ], # <
    [ -1,-1], # <^
    [ 0,-1 ]  # >^
);

sub FindWordsFrom
{
    my ($x,$y,$aref,$word,$coref) = @_;
    if (length($word) == 4)
    {
	return unless exists $w4{$word};
	print "$word: ";
	for $co (@$coref)
	{
	    print '(' . $co->[0] . ',' . $co->[1] . ')';
	}
	print "\n";
	return;
    }

    # we get here, we need to make the word longer.
    for (my $d = 0 ; $d < @dirs ; ++$d)
    {
	my $nx = $x + $dirs[$d]->[0];
	my $ny = $y + $dirs[$d]->[1];
	next if ($ny < 0 || $ny > 3);
	next if ($nx < 0 || $nx >= length($aref->[$ny]));
	next if substr($aref->[$ny],$nx,1) eq '.';

	my @lvar = @$aref;
	my @coar = @$coref;
	push @coar,[$nx,$ny];
	my $c = substr($lvar[$ny],$nx,1,'.');
	FindWordsFrom($nx,$ny,\@lvar,$word . $c,\@coar);
    }
}
		 






for ($y = 0 ; $y < @war ; ++$y)
{
    for ($x = 0 ; $x < length($war[$y]) ; ++$x)
    {
	my @lwar = @war;
	my $c = substr($lwar[$y],$x,1,'.');
	next if $c eq '.';
	FindWordsFrom($x,$y,\@lwar,$c,[[$x,$y]]);
    }
}

