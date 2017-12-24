die ("bad command line") unless @ARGV == 1;
open(FD,$ARGV[0]) || die("can't open file");
$lline = <FD> || die("file must have at least one line");
$lline =~ s/\r?\n$//;
@letters = split(//,$lline);
if ($aline = <FD>)
{
    $aline =~ s/\r?\n$//;
    @actors = split(" ",$aline);
}
while ($cline = <FD>)
{
    $cline =~ s/\r?\n$//;
    @parts = split(",",$cline);
    $lindex = $parts[0];
    $aindex = $parts[1];
    $key = $lindex . "_" . $aindex;
    $cell = {};
    if ($parts[2] eq '0')
    {
	$cell->{EMPTY} = 1;
    }
    else
    {
	for (my $i = 2 ; $i < @parts ; ++$i)
	{
	    ($type,$val) = $parts[$i] =~ /^([WL])(\d+)$/;
	    $cell->{$type} = $val;
	}
    }
    $cells{$key} = $cell;
}

sub GetOrCreateActor
{
    my ($name) = @_;
    for (my $i = 0 ; $i < @actors ; ++$i)
    {
	last if $actors[$i] eq $name;
    }
    return $i if $i < @actors;
    my $result = scalar @actors;
    push @actors,$name;
    return $result;
}





close FD;
my @used;

while(1)
{
    print "\t";
    for $actor (@actors)
    {
	print "\t",$actor;
    }
    print "\n";
    for ($l = 0 ; $l < @letters ; ++$l)
    {
	$letter = $letters[$l];
	print "*" if $used[$i];
	print $letter,"\t";
	for ($a = 0 ; $a < @actors ; ++$a)
	{
	    $actor = $actors[$a];
	    $key = $l . "_" . $a;
	    if (!exists $cells{$key})
	    {
		print "\t?";
	    }
	    elsif (exists $cells{$key}->{EMPTY})
	    {
		print "\t-";
	    }
	    elsif (exists $cells{$key}->{W})
	    {
		print "\tW:",$cells{$key}->{W};
	    }
	    else
	    {
		print "\t";
	    }
	}
	print "\n";
	print "\t";
	for ($a = 0 ; $a < @actors ; ++$a)
	{
	    $actor = $actors[$a];
	    $key = $l . "_" . $a;
	    if (!exists $cells{$key})
	    {
		print "\t?";
	    }
	    elsif (exists $cells{$key}->{EMPTY})
	    {
		print "\t-";
	    }
	    elsif (exists $cells{$key}->{L})
	    {
		print "\tL:",$cells{$key}->{L};
	    }
	    else
	    {
		print "\t";
	    }
	}
	print "\n";
    }


    for ($i = 0 ; $i < @letters ; ++$i)
    {
	last if (!$used[$i]);
    }
    last if $i == @letters;

    print "Selling letter(index): ";
    $lindex = <stdin>;
    $lindex =~ s/\r?\n$//;
    
    if ($used[$lindex])
    {
	print "bad index\n";
	next;
    }

    print "Winner(name): ";
    $wname = <stdin>;
    $wname =~ s/\r?\n$//;
    $widx = GetOrCreateActor($wname);
    
    print "Loser(names, space separated): ";
    $ls = <stdin>;
    $ls =~ s/\r?\n$//;
    @losers = split(/ /,$ls);
    for $lname (@losers) { push @lidx,GetOrCreateActor($lname); }
    
    print "winning bid: ";
    $wb = <stdin>;
    $wb =~ s/\r?\n$//;

    $used[$lindex] = 1;

    my $winnerkey = $lindex . "_" . $widx;

    if (!exists $cells{$winnerkey})
    {
	$cells{$winnerkey} = {};
    }

    if (exists $cells{$winnerkey}->{EMPTY})
    {
	die("winner was empty?");
    }

    if ($wb > $cells{$winnerkey}->{W})
    {
	$cells{$winnerkey}->{W} = $wb;
    }

    
	



    

    
    



	
