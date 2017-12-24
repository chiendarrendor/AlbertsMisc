use XML::DOM;

sub PrintTree
{
    my ($tree,$indent) = @_;

    print $indent,"Type: ",$tree->getNodeType," Name: ",$tree->getNodeName,"\n";
    print $indent,"Attrs:\n";
    if (defined $tree->getAttributes)
    {
	for my $attr ($tree->getAttributes->getValues)
	{
	    print $indent,"\t",$attr->getName,"=",$attr->getValue,"\n";
	}
    }
    print $indent,"Contents: |",$tree->getNodeValue,"|\n";
    print $indent,"Children:\n";
    for my $cnode ($tree->getChildNodes)
    {
	PrintTree($cnode,$indent . "\t");
    }
}

my @Players;
my $curdieroll;

sub ParsePlayers
{
    my ($players,$myname) = @_;
    for my $cnode ($players->getChildNodes)
    {
	next unless $cnode->getNodeName eq "player";
	my $name = $cnode->getAttributes->getNamedItem("name")->getValue;
	push @Players,$name;
	if ($cnode->getAttributes->getNamedItem("currentroll"))
	{
	    if ($name ne $myname)
	    {
		print "error Is not my turn!";
		exit(1);
	    }
	    $curdieroll = $cnode->getAttributes->getNamedItem("currentroll")->getValue;
	}
	# child node of player is 'tile', which can be used for calculating score/number of 
	# negative tiles/number of negators
    }
}

my @board;
my @moveable;

sub ParseBoard
{
    my ($board,$myname) = @_;
    my $tindex = 0;
    for my $cnode ($board->getChildNodes)
    {
	next unless $cnode->getNodeName eq "tile";
	my $curtile = { NAME => $cnode->getAttributes->getNamedItem("name")->getValue,TOKENS=>[]};

	if ($curtile->{NAME} eq "start" || $curtile->{NAME} eq "end")
	{
	    $curtile->{RAWVALUE} = 0;
	}
	elsif ($curtile->{NAME} =~ /plus_(\d+)/)
	{
	    $curtile->{RAWVALUE} = $1;
	}
	elsif($curtile->{NAME} =~ /minus_(\d+)/)
	{
	    $curtile->{RAWVALUE} = -($1);
	}
	else
	{
	    $curtile->{RAWVALUE} = 15;
	}

	push @board,$curtile;
	last if $curtile->{NAME} eq "end";

	my $pindex = 0;
	my $guardmove = 0;
	my @pendingguard;
	my @pendingmove;
	undef @pendingguard;
	undef @pendingmove;
	for my $pnode ($cnode->getChildNodes)
	{
	    if ($pnode->getNodeName eq "token")
	    {
		$guardmove = 1;
		$pname = 
		    $pnode->getAttributes->getNamedItem("owner")->getValue . "_" . 
		    $pnode->getAttributes->getNamedItem("id")->getValue;

		if ($pnode->getAttributes->getNamedItem("owner")->getValue eq $myname )
		{
		    push @pendingmove,[$tindex,$pindex];
		}
	    }
	    elsif ($pnode->getNodeName eq "guardian")
	    {
		$pname = "guardian_" . $pnode->getAttributes->getNamedItem("id")->getValue;
		push @pendingguard,[$tindex,$pindex];
	    }
	    else
	    {
		next;
	    }

	    push @{$curtile->{TOKENS}},$pname;
	    ++$pindex;
	}

	if ($guardmove)
	{
	    push @pendingmove,@pendingguard;
	}

	for (my $i = 0 ; $i < @pendingmove ; ++$i)
	{
	    if ($pindex > 1 || $curtile->{NAME} eq "start" || $curtile->{NAME} eq "end")
	    {
		push @moveable,$pendingmove[$i];
	    }
	    else
	    {
		push @moveable,[$pendingmove[$i]->[0],$pendingmove[$i]->[1],$curtile->{NAME}];
	    }
	}

	++$tindex;
    }
}

sub ParseTree
{
    my ($tree,$myname) = @_;

    for my $cnode ($tree->getChildNodes)
    {
	if ($cnode->getNodeName eq "players")
	{
	    ParsePlayers($cnode,$myname);
	}
	elsif($cnode->getNodeName eq "board")
	{
	    ParseBoard($cnode,$myname);
	}
    }
}




my ($myname,$boardfile,$statedir) = @ARGV;

my $parser = new XML::DOM::Parser;
my $doc = $parser->parsefile($boardfile);

my $docel = $doc->getDocumentElement;

ParseTree($docel,$myname);

#print join(",",@Players),"\n";
#print "Roll: ",$curdieroll,"\n";

for (my $i = 0 ; $i < @board ; ++$i)
{
#    print $board[$i]->{NAME},"(",$board[$i]->{RAWVALUE},")";
#    print ": ";
    for (my $j = 0 ; $j < @{$board[$i]->{TOKENS}} ; ++$j)
    {
#	print $board[$i]->{TOKENS}->[$j]," ";
    }
#    print "\n";
}

for (my $i = 0 ; $i < @moveable ; ++$i)
{
#    print "(",$moveable[$i]->[0],",",$moveable[$i]->[1],",",$moveable[$i]->[2],")\n";
}

my $r = int(rand(scalar @moveable));
my $p = $board[$moveable[$r]->[0]]->{TOKENS}->[$moveable[$r]->[1]];
@v = split("_",$p);
if ($v[0] eq $myname)
{
    print "token ",$v[1],"\n";
}
else
{
    print "guardian ",$v[1],"\n";
}

