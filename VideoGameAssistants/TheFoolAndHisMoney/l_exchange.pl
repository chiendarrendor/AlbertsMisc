# this program is to assist in the decoding of the 
# 'L' puzzles in TFAHM, where the correct ordering
# of a series of letters is required to decode the
# sentence.  
# This program also, as it turns out, works on the
# 'C' puzzles, too
#
# input, as a single argument on the command line
# a sentence as a result of pressing all the
# letters, i.e.
# perl l_exchange.pl 'Ac adefg hdffda ikc Lnopic Rntu nh ac wdefg.'
# (This example is from the second boy from the left in
#  'Lommis's Literals'
# Then, as prompted, choose two letters in the sentence
# and it will print the result of replacing the first
# with the second.

die("bad command line") if (@ARGV != 1);
$origsentence = $ARGV[0];

@origsentence = split('',$origsentence); 
foreach $let (@origsentence)
{
    $llet = lc($let);
    next if  ($llet lt 'a' || $llet gt 'z');
    $letters{$llet} = 1;
    $open{$llet} = 1;
    $unused{$llet} = 1;
}

print join(",",sort keys %letters),"\n";

sub ExchangePrint
{
    foreach $let (@origsentence)
    {
	$llet = lc($let);
	if ($llet lt 'a' || $llet gt 'z') 
	{
	    print $llet;
	    next;
	}
	if (!exists($replacement{$llet}))
	{
	    print '#';
	    next;
	}
	$rlet = $replacement{$llet};
	if ($let ge 'a' && $let le 'z')
	{
	    print $rlet;
	}
	else
	{
	    print uc($rlet);
	}
    }
    print "\n";
}

# keeping track of four items:
# open -- letters from the original sentence that are untransformed
# closed -- lettes from the original sentence that are transformed
# unused -- transforming letters that have not been used
# used -- transforming letters that have been used



while(1)
{
    print "original: ",join(",",sort keys %open),"/",join(",",sort keys %closed),"\n";
    print " replace: ",join(",",sort keys %unused),"/",join(",",sort keys %used),"\n";
    print $origsentence,"\n";
    ExchangePrint();
    
    print "exchange: ";
    $tc = <stdin>;
    chomp $tc;
    if (length($tc) == 1)
    {
	if (!exists($closed{$tc}))
	{
	    print "No such used original letter.\n";
	    next;
	}
	delete $used{$replacement{$tc}};
	$unused{$replacement{$tc}} = 1;
	delete $closed{$tc};
	$open{$tc} = 1;
	delete $replacement{$tc};
    }
    else
    {
	$from = substr($tc,0,1);
	$to = substr($tc,1,1);
	if (!exists($open{$from}))
	{
	    print "no such unused original letter.\n";
	    next;
	}
	if (!exists($unused{$to}))
	{
	    print "no such unused replacement letter.\n";
	    next;
	}
	delete $open{$from};
	delete $unused{$to};
	$closed{$from} = 1;
	$used{$to} = 1;
	$replacement{$from} = $to;
    }
}

