@sary = (
	 "00001",
	 "00010",
	 "00011",
	 "00100",
	 "00101",
	 "00110",
	 "00111",
	 "01000",
	 "01001",
	 "01010",
	 "01011",
	 "01100",
	 "01101",
	 "01110",
	 "01111",
	 "10000",
	 "10001",
	 "10010",
	 "10011",
	 "10100",
	 "10101",
	 "10110",
	 "10111",
	 "11000",
	 "11001",
	 "11010",
	 "11011",
	 "11100",
	 "11101",
	 "11110"
	 );

sub AllMatches
{
    my ($tstr) = @_;
    for (my $i = 0 ; $i < @sary ; ++$i)
    {
	if (index($tstr,$sary[$i]) == -1)
	{
	    return undef;
	}
    }
    return 1;
}


sub AllOnes
{
    my ($seq) = @_;
    my @aoary=split(//,$seq);

    for (my $i = 0 ; $i < @aoary ; ++$i)
    {
	if ($aoary[$i] ne '1') 
	{
	    return undef;
	}
    }
    return 1;
}

sub Increment
{
    my ($seq) = @_;
    my @iary=split(//,$seq);

    # 00100
    # 11001

    my $i;
    my $j;

    for ($i = 0 ; $i < @iary ; ++$i)
    {
	if ($iary[$i] eq '0')
	{
	    $iary[$i] = '1';
	    last;
	}
    }

    # _1_0100
    # 11_1_01

    for ($j = 0 ; $j < $i ; ++$j)
    {
	$iary[$j] = '0';
    }

    # 10100
    # 00101
	 
    return join("",@iary);
}


my $seqlength;
$| = 1;

for ($seqlength = 6 ; $seqlength < 30 ; ++$seqlength)
{
    print "Starting seqs of length $seqlength\n";
    my $seq = "0" x $seqlength;
    for( Increment($seq) ; !AllOnes($seq) ; $seq = Increment($seq) )
    {
	if (AllMatches($seq))
	{
	    print "Found! " , $seq , "\n";
	    exit(0);
	}
    }
}

