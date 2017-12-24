package Board;


sub new
{
    my ($class,$other) = @_;
    my $this = {};

    bless $this,$class;

    if (ref($other) && $ref->isa($class))
    {
	# copy constructor behavior goes here
	return $this;
    }

    # otherwise, other should be a file name
    open(RFD,"<$other") || die("can't load from file $other\n");

    # file format
    # one or more lines of one or more white-space separated blocks of:
    # (\d+)?[vV<>^]{1,2}
    # each line must have the same number of blocks

    $this->{WIDTH} = -1;
    $this->{HEIGHT} = 0;
    while(<RFD>)
    {
	# at this point, height is the index of the Y-coordinate of the current row.
	chomp;
	my @blocks = split;
	if ($this->{WIDTH} == -1)
	{
	    $this->{WIDTH} = scalar @blocks;
	}
	elsif($this->{WIDTH} != scalar @blocks)
	{
	    die("illegal file format: line ".scalar @blocks." (0-based) has wrong number of blocks\n");
	}

	for (my $x = 0 ; $x < @blocks ; ++$x)
	{
	    if ($blocks[$x] !~ /^(\d+)?([Vv<>^]{0,2})$/)
	    {
		die("illegal file format: block ".$blocks[$i]." in illegal format\n");
	    }

	    my $t =  {
		X => $x,
		Y => $this->{HEIGHT},
		NUM => $1,
		FROM => [],
		TO => []
		};

	    ++$t->{DX} if index($2,'>') != -1;
	    --$t->{DX} if index($2,'<') != -1;
	    ++$t->{DY} if index($2,'V') != -1 || index($2,'v') != -1;
	    --$t->{DY} if index($2,'^') != -1;

	    $this->{BLOCKS}->{$x,$this->{HEIGHT}} = $t;
	}		
	$this->{HEIGHT}++;
    }
    close(RFD);

    # validate that no block has num > width * height
    # one block should be NUM = 1, and another should be
    # NUM = width * height (this one should have no DX or DY
    my %blocknums;
    my $maxn = $this->{WIDTH} * $this->{HEIGHT};
    foreach my $key (keys %{$this->{BLOCKS}})
    {
	my $block = $this->{BLOCKS}->{$key};
	die("illegal number: ".$block->{NUM}) if $block->{NUM} > $maxn;
	++$blocknums{$block->{NUM}} if $block->{NUM};

	if ($block->{DX} == 0 && $block->{DY} == 0)
	{
	    die("only terminal space may have no arrows\n") if $block->{NUM} != $maxn;
	}
    }
    die("no start space\n") if $blocknums{1} == 0;
    die("no terminal space\n") if $blocknums{$maxn} == 0;

    foreach my $key ( keys %blocknums)
    {
	die("duplicate number $key\n") if $blocknums{$key} > 1;
    }

    # linkthreading 

    foreach my $key ( keys %{$this->{BLOCKS}})
    {
	my $block = $this->{BLOCKS}->{$key};
	next if $block->{DX} == 0 && $block->{DY} == 0;

	my $cx = $block->{X} + $block->{DX};
	my $cy = $block->{Y} + $block->{DY};
	while($cx >= 0 && $cx < $this->{WIDTH} &&
	      $cy >= 0 && $cy < $this->{HEIGHT})
	{
	    push @{$block->{TO}},$this->{BLOCKS}->{$cx,$cy};
	    push @{$this->{BLOCKS}->{$cx,$cy}->{FROM}},$block;

	    $cx += $block->{DX};
	    $cy += $block->{DY};
	}
    }	    

    return $this;
}




sub Show
{
    my ($this) = @_;

    for (my $y = 0 ; $y < $this->{HEIGHT} ; ++$y)
    {
	for (my $x = 0 ; $x < $this->{WIDTH} ; ++$x)
	{
	    my $block = $this->{BLOCKS}->{$x,$y};
	    print $block->{NUM} if $block->{NUM} != 0;
	    print '<' if $block->{DX} < 0;
	    print '>' if $block->{DX} > 0;
	    print '^' if $block->{DY} < 0;
	    print 'v' if $block->{DY} > 0;
	    print "\t";
	}
	print "\n";
    }

    for (my $y = 0 ; $y < $this->{HEIGHT} ; ++$y)
    {
	for (my $x = 0 ; $x < $this->{WIDTH} ; ++$x)
	{
	    my $block = $this->{BLOCKS}->{$x,$y};
	    print "($x,$y): ";
	    
	    for (my $r = 0 ; $r < @{$block->{TO}} ; ++$r)
	    {
		print "(",$block->{TO}->[$r]->{X},",",$block->{TO}->[$r]->{Y},") ";
	    }
	    print "/ ";
	    for (my $r = 0 ; $r < @{$block->{FROM}} ; ++$r)
	    {
		print "(",$block->{FROM}->[$r]->{X},",",$block->{FROM}->[$r]->{Y},") ";
	    }
	    print "\n";
	}
    }
}

sub RemoveLink
{
    my ($from,$to) = @_;
    my $i;
    for ($i = 0 ; $i < @{$from->{TO}} ; ++$i)
    {
	splice(@{$from->{TO}},$i,1) if $from->{TO}->[$i] == $to;
    }
    for ($i = 0 ; $i < @{$to->{FROM}} ; ++$i)
    {
	splice(@{$to->{FROM}},$i,1) if $to->{FROM}->[$i] == $from;
    }
}

# if a block has a unique to,
#  i.e. A -> B
#  remove all X -> B where X != A (both ends)
#  do the same for all unique from's
sub ClearSingles
{
    my ($this) = @_;
    my $delcount = 0;
    foreach my $key ( keys %{$this->{BLOCKS}})
    {
	my $block = $this->{BLOCKS}->{$key};
	
	if (scalar @{$block->{TO}} == 1)
	{
	    my $tblock = $block->{TO}->[0];
	    foreach my $xblock ( @{$tblock->{FROM}})
	    {
		next if $xblock == $block;
		++$delcount;
		RemoveLink($xblock,$tblock);
	    }
	}
	
	if (scalar @{$block->{FROM}} == 1)
	{
	    my $tblock = $block->{FROM}->[0];
	    foreach my $xblock ( @{$tblock->{TO}})
	    {
		next if $xblock == $block;
		++$delcount;
		RemoveLink($tblock,$xblock);
	    }
	}
    }
    return $delcount;
}






package main;

$b = new Board("t1.txt");
$b->Show;

while(1)
{
    $dc = $b->ClearSingles();
    print "$dc Deleted\n";
    last if $dc == 0;
}

print "---\n";
$b->Show;








	

