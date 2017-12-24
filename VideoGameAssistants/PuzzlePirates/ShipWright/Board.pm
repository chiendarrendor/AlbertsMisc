package Board;

use Patterns;

sub new
{
    my ($class,$file,$patterns) = @_;

    my $this = {};
    bless ($this,$class);
    $this->{DEPTH} = 0;
    $this->{MOVE} = "";

    open(BFILE,$file) || die("Can't open file $file\n");

    my $i;
    my $j;
    my $lineno = 0;

    while(<BFILE>)
    {
	chomp;

	if ($lineno < 5)
	{
	    for ($i = 0 ; $i < 5 ; ++$i)
	    {
		$this->SetCell($i,$lineno,substr($_,$i,1));
	    }
	}
	elsif($lineno < 11)
	{
	    my $pat = $patterns->GetPattern($_);
	    die("Can't find pattern ($_)\n") unless $pat;
	    push @{$this->{PATTERNS}},$pat;
	}
	else
	{
	    return $this;
	}
	$lineno++;
    }
    die("File too short!\n") unless $lineno > 10;

    return $this;
}

sub SetCell
{
    my ($this,$x,$y,$value) = @_;
    $this->{BOARD}->[$x][$y] = $value;
}

sub GetCell
{
    my ($this,$x,$y) = @_;
    return $this->{BOARD}->[$x][$y];
}

sub SwapClone
{
    my ($this,$x1,$y1,$x2,$y2) = @_;
    my $i;
    my $j;
    my $newboard = {};
    bless($newboard,ref $this);
    
    for ($i = 0 ; $i < 5 ; $i++)
    {
	for ($j = 0 ; $j < 5 ; $j++)
	{
	    $newboard->SetCell($i,$j,$this->GetCell($i,$j));
	}
    }

    for ($i = 0 ; $i < @{$this->{PATTERNS}} ; $i++)
    {
	push @{$newboard->{PATTERNS}},$this->{PATTERNS}[$i];
    }

    $newboard->{DEPTH} = $this->{DEPTH} + 1;
    $newboard->SetCell($x1,$y1,$this->GetCell($x2,$y2));
    $newboard->SetCell($x2,$y2,$this->GetCell($x1,$y1));
    $newboard->{MOVE} = $this->GetCell($x1,$y1) . "(".($x1+1).",".($y1+1).")->(".($x2+1).",".($y2+1).")";
    $newboard->{PARENT} = $this;

    return $newboard;
}

sub CanonicalKey
{
    my ($this) = @_;
    my $i;
    my $j;
    my $result;

    for ($i = 0 ; $i < 5 ; $i++)
    {
	for ($j = 0 ; $j < 5 ; $j++)
	{
	    $result .= $this->GetCell($i,$j);
	}
    }
    return $result;
}



sub Successors
{
    my ($this) = @_;
    my @result;
    my $i,$j;

    for ($i = 0 ; $i < 5 ; ++$i)
    {
	for ($j = 0 ; $j < 5 ; ++$j)
	{
	    my $cell = $this->GetCell($i,$j);
	    if ($cell eq 'I')
	    {
		if ($i != 0)	{   push @result,$this->SwapClone($i,$j,$i-1,$j); }
		if ($i != 4)	{   push @result,$this->SwapClone($i,$j,$i+1,$j); }
	    }		    
	    if ($cell eq 'W')
	    {
		if ($j != 0)	{   push @result,$this->SwapClone($i,$j,$i,$j-1); }
		if ($j != 4)	{   push @result,$this->SwapClone($i,$j,$i,$j+1); }
	    }		    
	    if ($cell eq 'R')
	    {
		if ($i != 0 && $j != 0)	{ push @result,$this->SwapClone($i,$j,$i-1,$j-1); }
		if ($i != 0 && $j != 4)	{ push @result,$this->SwapClone($i,$j,$i-1,$j+1); }
		if ($i != 4 && $j != 0)	{ push @result,$this->SwapClone($i,$j,$i+1,$j-1); }
		if ($i != 4 && $j != 4)	{ push @result,$this->SwapClone($i,$j,$i+1,$j+1); }
	    }
	}    
    }
    return @result;
}




sub PatternMatchesAtLocation
{
    my ($this,$x,$y,$pat) = @_;
    my $patwidth = $pat->GetWidth();
    my $patheight = $pat->GetHeight();


    return undef if ($x + $patwidth > 5);
    return undef if ($y + $patheight > 5);

    my $i;
    my $j;
    for ($i = 0 ; $i < $patwidth ; ++$i)
    {
	for ($j = 0 ; $j < $patheight ; ++$j)
	{
	    my $patcell = $pat->GetCell($i,$j);
	    my $bcell = $this->GetCell($i+$x,$j+$y);

	    next if $patcell eq '.';
	    return undef if $patcell ne $bcell;
	}
    }
    return true;
}

sub GetPatternMatches
{
    my ($this,$pattern) = @_;
    my $i;
    my $j;
    my @result;

    for ($i = 0 ; $i < 5 ; ++ $i)
    {
	for ($j = 0 ; $j < 5 ; ++ $j)
	{
	    next unless $this->PatternMatchesAtLocation($i,$j,$pattern);
	    my $match = {};
	    $match->{X} = $i;
	    $match->{Y} = $j;
	    $match->{PATTERN} = $pattern;
	    push @result,$match;
	}
    }
    return @result;
}

sub GetMatches
{
    my ($this) = @_;
    my $i;
    my @result;
    my @patresult;

    for ($i = 0 ; $i < @{$this->{PATTERNS}} ; ++$i)
    {
	undef @patresult;

	@patresult = $this->GetPatternMatches($this->{PATTERNS}[$i]);

	push @result,@patresult;
    }

    return @result;
}

sub BoolVecInitialize
{
    my ($count) = @_;
    my $result = {};
    $result->{CUR} = 0;
    $result->{MAX} = (2 ** $count) - 1;
    return $result;
}

sub BoolVecMaximum
{
    my ($boolvec) = @_;

    return $boolvec->{CUR} == $boolvec->{MAX}+1;
}

sub BoolVecIncrement
{
    my ($boolvec) = @_;
    $boolvec->{CUR}++;
}

sub BoolVecApply
{
    my ($boolvec,@allmatches) = @_;
    my @result;
    my $i;

    for ($i = 0 ; $i < @allmatches ; ++$i)
    {
	if ($boolvec->{CUR} & (1 << $i))
	{
	    push @result,$allmatches[$i];
	}
    }
    return @result;
}

sub MatchName
{
    my ($match) = @_;
    return $match->{PATTERN}->GetName()."-".$match->{X}."-".$match->{Y};
}

sub HasDuplicates
{
    my (@matches) = @_;

    my %names;
    my $i;

    for ($i = 0 ; $i < @matches ; ++$i)
    {
	my $name = $matches[$i]->{PATTERN}->GetName();
	$names{$name}++;
	return 1 if $names{$name} > 1;
    }
    return 0;
}

sub HasOverlaps
{
    my (@matches) = @_;
    my %cells;
    my $match;
    my $i;
    my $j;

    foreach $match (@matches)
    {
	my $pat = $match->{PATTERN};
	my $patwidth = $pat->GetWidth();
	my $patheight = $pat->GetHeight();

	for ($i = 0 ; $i < $patwidth ; ++$i)
	{
	    for ($j = 0 ; $j < $patheight ; ++$j)
	    {
		next if $pat->GetCell($i,$j) eq '.';
		my $cellkey = ($match->{X}+$i) . "-" . ($match->{Y} + $j);
		$cells{$cellkey}++;
		return 1 if $cells{$cellkey} > 1;
	    }
	}
    }
    return 0;
}

sub FindBestMatches
{
    my ($this) = @_;
    my @allmatches = $this->GetMatches();

    $this->{GRADE} = 0;
    
    my $boolvec;

    for ($boolvec = BoolVecInitialize(scalar @allmatches),BoolVecIncrement($boolvec);
	 !BoolVecMaximum($boolvec);
	 BoolVecIncrement($boolvec))
    {
	my @matchlist = BoolVecApply($boolvec,@allmatches);
	my $grade = 0;

	next if (HasDuplicates(@matchlist));
	next if (HasOverlaps(@matchlist));

	for ($i = 0 ; $i < @matchlist ; $i++)
	{
	    $grade += $matchlist[$i]->{PATTERN}->GetGrade();
	}

	if ($grade > $this->{GRADE})
	{
	    @{$this->{MATCHES}} = @matchlist;
	    $this->{GRADE} = $grade;
	}
    }
}

1;


	    
    
    
