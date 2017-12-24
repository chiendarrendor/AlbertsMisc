use AuctionItem;

my $letters;
my @queue;
my @dropped;
my @good;
my @duplicates;
# key is <used letters, sorted alphabetically> 
my %uniques;
my $restart = 0;

sub RewriteFile
{
    my ($fname) = @_;
    open(RFD,">$fname");
    print RFD join("",$letters),"\n";
    for my $u (keys %uniques)
    {
	print RFD $u,"\n";
    }
    print RFD "end\n";

    for my $item (@queue)
    {
	print RFD $item->Serialize('Q'),"\n";
    }
    for my $item (@dropped)
    {
	print RFD $item->Serialize('D'),"\n";
    }
    for my $item (@good)
    {
	print RFD $item->Serialize('G'),"\n";
    }
    for my $item (@duplicates)
    {
	print RFD $item->Serialize('C'),"\n";
    }
    close(RFD);
}

sub enqueue
{
    my ($item) = @_;
    push @queue,$item;
}

sub RequeueNext
{
    my ($item) = @_;

    my $k = $item->GetCanonicalKey();

#    if (exists $uniques{$k})
#    {
#	print "queue duplicate detected\n";
#	push @duplicates,$item;
#	return;
#    }
    $uniques{$k} = 1;

    for $letter (@{$item->{LETTERS}->GetUnused()})
    {
	$ni = $item->clone();
	$ni->AddPending($letter);
	enqueue($ni);
    }
}

sub ReadFile
{
    my ($fname) = @_;
    open(RFD,$fname) || die("can't open file");
    my $inuniques = 1;
    my $isfirst = 1;

    while(<RFD>)
    {
	$_ =~ s/\r?\n$//;
	next unless length($_) > 0;

	if ($isfirst)
	{
	    $letters = $_;
	    $isfirst = 0;
	    next;
	}

	$restart = 1;
	
	if ($inuniques)
	{
	    if ($_ eq 'end')
	    {
		$inuniques = 0;
	    }
	    else
	    {
		$uniques{$_} = 1;
	    }
	    next;
	}

	my $ni = new AuctionItem($letters);
	my $t = $ni->Deserialize($_);
	if    ($t eq 'C') { push @duplicates,$ni; }
	elsif ($t eq 'G') { push @good,$ni; }
	elsif ($t eq 'D') { push @dropped,$ni; }
	# this uses push and not enqueue so that it doesn't do the duplicate check.
	# of course all the pending items in the queue have a duplicate record.
	elsif ($t eq 'Q' && exists $ni->{PENDING}) { push @queue,$ni; }
	elsif ($t eq 'Q')
	{
	    RequeueNext($ni);
	}
	else { die("unknown queue code $t"); }
    }
    close RFD;

    @queue = sort { scalar @{$b->{UNUSED}} <=> scalar @{$a->{UNUSED}} } @queue;

}

sub NewStart
{
    $lm = new LetterManager($letters);
    for $letter (@{$lm->GetUnused()})
    {
	$ni = new AuctionItem($letters);
	$ni->AddPending($letter);
	enqueue($ni);
    }
}

sub QueueDepth
{
    my $result;
    for my $qi (@queue) { $result += $qi->depth(); }
    return $result;
}

sub commify
{
    my $input = shift;

    $input = reverse $input;
    my $output = "";
    while(1)
    {
	my $t = substr($input,0,3,"");
	$output .= $t;
	last if length($input) == 0;
	$output .= ',';
    }

    $output = reverse $output;
    return $output;
}


###################################
# start of main code
###################################

die("bad command line") unless @ARGV == 1;
ReadFile($ARGV[0]);	

NewStart() if $restart == 0;


while (@queue > 0)
{
    print commify(QueueDepth())," paths in ", scalar @queue," items:\n";

    my $qi = shift @queue;

    # all items in queue are pending.
    my $result = $qi->ProcessPending();
    if ($result == -1) {} # yup...do nothing.
    elsif ($result == 0) { push @dropped,$qi; }
    elsif ($qi->{LETTERS}->AllUsed()) { push @good,$ni; }
    else
    {
	RequeueNext($qi);
    }

    RewriteFile($ARGV[0]);
}



    
