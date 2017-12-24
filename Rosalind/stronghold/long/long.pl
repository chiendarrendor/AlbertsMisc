
sub min { my ($a,$b) = @_; return $a < $b ? $a : $b; }

my $minoverlap;

# the two strings must overlap by at least $minoverlap
# nucleotides.

sub FindOverlapIndex
{
    my ($master,$slave) = @_;
    my $i;
    my $j;
    my $result = [];

    my $lm = length($master);
    my $maxoff = $lm - $minoverlap;

    for ($i = 0 ; $i < $maxoff ; ++$i)
    {
	my $terminal = min(length($master),
			   $i + length($slave));

	for ($j = $i ; $j < $terminal ; ++$j)
	{
	    last unless substr($master,$j,1) eq substr($slave,$j-$i,1);
	}
	push @$result,$i if $j == length($master);
    }
    return $result;
}

sub PrintStrings
{
    print "-------------\n";
    for (my $i = 0 ; $i < @strings ; ++$i)
    {
	print $strings[$i]->{STRING},"\n";
	print "  TO: ";
	for my $to (@{$strings[$i]->{TO}})
	{
	    print '(' , $to->[0],',',$to->[1],')';
	}
	print "\n";

	print "  FROM: ";
	for my $from (@{$strings[$i]->{FROM}})
	{
	    print '(' , $from->[0],',',$from->[1],')';
	}
	print "\n";
    }
}

sub FindOverlaps
{
    my $i;
    my $j;
    my $indexes;
    my $index;

    for ($i = 0 ; $i < @strings ; ++$i)
    {
	delete $strings[$i]->{FROM};
	delete $strings[$i]->{TO};
    }	

    # step 1.  find overlaps of more than 50%
    for ($i = 0 ; $i < @strings ; ++$i)
    {
	for ($j = 0 ; $j < @strings ; ++$j)
	{
	    next if $i == $j;
	    $indexes = FindOverlapIndex($strings[$i]->{STRING},$strings[$j]->{STRING});

	    for $idx (@$indexes)
	    {
		push @{$strings[$i]->{TO}},[$j,$idx];
		push @{$strings[$j]->{FROM}},[$i,$idx];
	    }
	}
    }
}
    


die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");

while(<FD>)
{
    $_ =~ s/\r?\n$//;
    push @strings, { STRING=>$_ };
    $minoverlap = length($_);
}
close FD;
$minoverlap /= 2;


FindOverlaps();
#PrintStrings();

while(@strings > 1)
{
    # find a strings that connects in only one way
    # to another string.
    for ($i = 0 ; $i < @strings ; ++$i)
    {
	last if 
	    (scalar @{$strings[$i]->{FROM}} + scalar@{$strings[$i]->{TO}}) == 1;
    }
    die("need better guessing!") if $i == @strings;

    if (@{$strings[$i]->{TO}} == 1)
    {
	$left = $i;
	$right = $strings[$i]->{TO}->[0]->[0];
	$offset = $strings[$i]->{TO}->[0]->[1];
    }
    else
    {
	$right = $i;
	$left = $strings[$i]->{FROM}->[0]->[0];
	$offset = $strings[$i]->{FROM}->[0]->[1];
    }

    $news = $strings[$left]->{STRING};
    substr($news,$offset,length($news)-$offset,$strings[$right]->{STRING});

    push @strings, { STRING=>$news };

    if ($left > $right)
    {
	splice(@strings,$left,1);
	splice(@strings,$right,1);
    }
    else
    {
	splice(@strings,$right,1);
	splice(@strings,$left,1);
    }

	
    FindOverlaps();
#    PrintStrings();
}	

print $strings[0]->{STRING},"\n";


	













