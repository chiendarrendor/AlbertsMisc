use HexBoard;

@w4 = split("\n",`grep -E '^.{4}\$' wordsEn.txt`);
for $w (@w4) { $w4{$w} = 1; }

delete $w4{arse};
delete $w4{jars};
delete $w4{ares};
delete $w4{eses};
delete $w4{asea};
delete $w4{seas};
delete $w4{ells};
delete $w4{eels};
delete $w4{lese};
delete $w4{esse};
delete $w4{lear};
delete $w4{leas};
delete $w4{leal};
delete $w4{alls};
delete $w4{ears};
delete $w4{jess};
delete $w4{lees};
delete $w4{rara};
delete $w4{sera};
delete $w4{sere};
delete $w4{alee};
delete $w4{sees};




@war = 
(
 "ajarsall",
 "rareeesl",
 "slejease",
 "ellelssa"
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

my @wordlist;


sub FindWordsFrom
{
    my ($x,$y,$aref,$word,$coref) = @_;
    if (length($word) == 4)
    {
	return unless exists $w4{$word};

	my $newrec = [ $word,
		       $coref->[0]->[0],$coref->[0]->[1],
		       $coref->[1]->[0],$coref->[1]->[1],
		       $coref->[2]->[0],$coref->[2]->[1],
		       $coref->[3]->[0],$coref->[3]->[1] ];

	push @wordlist,$newrec;
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

for ($i = 0 ; $i < @wordlist ; ++$i)
{
    $uwords{$wordlist[$i]->[0]}++;
}

print scalar keys %uwords," ";

print "Unique Words: ",join(",",sort keys %uwords),"\n";

$firstBoard = new HexBoard();
for ($i = 0 ; $i < @wordlist ; ++$i)
{
    $firstBoard->NewWord(@{$wordlist[$i]});
}

push @queue,$firstBoard;

while(@queue)
{
    @queue = sort { $b->UsedWordCount() <=> $a->UsedWordCount() } @queue;

    print "queue size ",scalar @queue,"\n";
    $opb = shift @queue;

    if ($opb->UsedWordCount() == 8)
    {
	push @solved,$opb;
	last;
    }

    $wc = $opb->UnusedWordCount();
    next if ($wc == 0);

    for ($i = 0 ; $i < $wc ; ++$i)
    {
	$nb = $opb->Clone();
	$nb->UseWordByIndex($i);
	push @queue,$nb;
    }
}

print "Processing done: ",scalar @solved," boards found:\n";
for ($i = 0 ; $i < @solved ; ++$i)
{
    $solved[$i]->PrintBoard();
}



    

