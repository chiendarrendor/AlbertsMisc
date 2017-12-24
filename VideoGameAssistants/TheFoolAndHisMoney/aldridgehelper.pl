use AldridgeItem;

AldridgeItem::Initialize();

$c1 = "midcmmcwhiwrddksnysb";
$c2 = "gfbkstuedmwketltpuma";
# 1 bridegroom/dressmaker g,b,d,m
$c1 = "icmmcwhiwrddksnysb";
$c2 = "fkstuedmwketltpuma";
# 2a soundproof/mouthpiece s,i,m,f
$c1 = "cmcwhiwrddksnysb";
$c2 = "ktuedmwketltpuma";
# 2b courthouse/sweetheart c,u,w,e
# 2a->3a courthouse/sweetheart c,u,w,e
# 2a->3b blacksmith/smokestack c,m,k,t
# 2a->3b->4a courthouse/sweetheart c,u,w,e
$c1 = "wrddksnysb";
$c2 = "dwketltpuma";
# 2a->3b->4a->5a chalkboard/brainstorm i,m,d1,h
$c1 = "wrdksnysb";
$c2 = "dwketltpuma";
# 2a->3b->4a->5a chalkboard/brainstorm i,m,d2,h
#$c1 = "wrddksnysb";
#$c2 = "wketltpuma";
# 5a1->6a watchtower/earthquake
# 6a->7a waterwheel/grindstone
# 7a->8a undertaker/tablecloth

#   cors  aelp
#   deer  aces
#   eerv  bder
#   ghit  bcru
#b breed        2
#s cross        2
#y every        2
#n thing        2
#a        bread 1
#m        crumb 2
#u        sauce 2
#p        apple 2


@actors = 
(
# [ "ackl" , "abor" , "abnr" , "orst" ],
# [ "deir" , "moor" , "erss" , "aekr" ],
 [ "enru" , "aert" , "abel" , "chot" ],
# [ "ortu" , "ehos" , "eest" , "ahrt" ],
# [ "abkl" , "hist" , "emos" , "acks" ],
 [ "aerw" , "ehlw" , "ginr" , "enot" ],
# [ "dnou" , "oopr" , "hotu" , "ceep" ],
 [ "acht" , "eort" , "aeht" , "aequ" ],

# [ "cors" , "deer" , "eerv" , "ghit" ], # one of the last two
# [ "aelp" , "aces" , "bder" , "bcru" ], # one of the last two
);

my @queue;
for (my $i = 0 ; $i < @actors ; ++$i)
{
    push @queue,new AldridgeItem($actors[$i],$c1,$c2);
}

my @result;

while (@queue)
{
    my $qi = shift @queue;
    if ($qi->IsGood())
    {
	push @result,$qi;
    }
    else
    {
	$qr = $qi->Process();
	next if !$qr || @$qr == 0;
	push @queue,@$qr;
    }
}

for $qi (@result)
{
    push @{$bykey{$qi->{TENWORDS}->[0]}},$qi;
}


while(1)
{
    for $key (sort keys %bykey)
    {
	print "tenword: $key\n";
	for $qi (@{$bykey{$key}})
	{
	    print "  ";
	    my $first = 1;
	    for my $r (@{$qi->{RESULT}})
	    {
		print " -- " unless $first;
		$first = 0;
		print $r->[0] , '(' , $r->[1] , ')->' , $r->[2];
	    }
	    print "\n";
	}
    }
    print "letter pressed: ";
    $lp = <stdin>;
    chomp $lp;
    print "word gotten: ";
    $wg = <stdin>;
    chomp $wg;
    for $key (keys %bykey)
    {
	my $newl = [];
	for $qi (@{$bykey{$key}})
	{
	    my $newr = [];
	    my $r = $qi->{RESULT}->[0];
	    my $rl =  $r->[0] . '(' . $r->[1] . ')';
	    if ($lp eq $rl && $wg ne $r->[2])
	    {
		next;
	    }
	    push @$newl,$qi;
	}
	$bykey{$key} = $newl;
	if (scalar @$newl == 0)
	{
	    delete $bykey{$key};
	}
    }
}




	
