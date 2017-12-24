
my @queue;
my $start = { AP=>'L', NUM=>15,CHILDREN=>[]};
push @queue, $start;

while(@queue) {
    $rec = pop @queue;
    for (my $i = 1 ; $i <= 3 ; ++$i) {
	next if ($i > $rec->{NUM});
	my $tp = $rec->{AP} eq 'L' ? 'J' : 'L';
	my $n = $rec->{NUM} - $i;
	my $nn = {AP=>$tp,NUM=>$n,CHILDREN=>[],MOVE=>$i};
	push @{$rec->{CHILDREN}},$nn;
	if ($nn->{NUM} == 0) 
	{ 
	    $nn->{END} = 'wins';
	} 
	else
	{
	    push @queue,$nn;
	}
    }
}

RecProcess($start);


sub RecProcess
{
    my ($this) = @_;
    return $this->{END} if exists $this->{END};
    my $wcount = 0;
    my $lcount = 0;
    my $wmove;
    for my $ch (@{$this->{CHILDREN}}) {
	my $res = RecProcess($ch);
	if ($res eq 'wins') { ++$wcount; }
	else { ++$lcount; $wmove = $ch->{MOVE}; }
    }
    if ($lcount == 0) {
	$this->{END} = 'loses';
	return 'loses';
    } else {
	$this->{END} = 'wins';
	$this->{WMOVE} = $wmove;
	return 'wins';
    }
}


RecPrint($start,'');

sub RecPrint
{
    my ($thing,$indent) = @_;
    print $indent;
    if (exists $thing->{MOVE}) {
	print "(",$thing->{MOVE},")";
    }
    print "To Play: ",$thing->{AP}," on ",$thing->{NUM};
    if (exists $thing->{END}) {
	print " ",$thing->{END};
	if ($thing->{END} eq 'wins') { 
	    print "(",$thing->{WMOVE},")";
	}
    }
    print "\n";
#    for my $nth (@{$thing->{CHILDREN}}) {
#	RecPrint($nth,$indent . "     ");
#    }
}

	
    
    
