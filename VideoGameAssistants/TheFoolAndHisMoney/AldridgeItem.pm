package AldridgeItem;

my %short5;
my @short5;
my %fw10;

sub Initialize
{
    @w5 = split("\n",`grep -E '^.{5}\$' wordsEn.txt`);
    for $word (@w5)
    {
	$fivewords{$word} = 1;
    }
    print scalar keys %fivewords, " 5-letter words loaded\n";
    
    @w10 = split("\n",`grep -E '^.{10}\$' wordsEn.txt`);
    for $word (@w10)
    {
	$s1 = substr($word,0,5);
	$s2 = substr($word,5,5);
	next unless exists $fivewords{$s1} && exists $fivewords{$s2};
	$fw10{$word} = 1;
	$short5{$s1} = 1;
	$short5{$s2} = 1;
    }

    $short5{bread} = 1;
    $short5{crumb} = 1;
    $fw10{breadcrumb} = 1;


    print scalar @w10," 10-letter words loaded, ",
       scalar keys %fw10," after compound filtering\n";

    @short5 = sort keys %short5;

    print scalar keys %short5," 5-letter words are part of a 10-letter word\n";

}

# returns a ref to an array containing all the words in short5
# that have the same set of letters as the given word.
sub WordList
{
    my ($tw) = @_;
    my $result = [];
    my @twl = sort split("",$tw);
    for my $w (@short5)
    {
	my @wwl = sort split("",$w);
	next unless ($twl[0] eq $wwl[0] &&
		     $twl[1] eq $wwl[1] &&
		     $twl[2] eq $wwl[2] &&
		     $twl[3] eq $wwl[3] &&
		     $twl[4] eq $wwl[4]);
	push @$result,$w;
    }
    return $result;
}

sub IsTenWord
{
    my ($this,$i1,$i2,$i3,$i4) = @_;
    my $w1 = $this->{WORDS}->[$i1] . $this->{WORDS}->[$i2];
    my $w2 = $this->{WORDS}->[$i3] . $this->{WORDS}->[$i4];
    return undef unless exists $fw10{$w1} && exists $fw10{$w2};
    my $result = "$w1/$w2";
    return $result;
}

sub new
{
    my ($class,$bases,$let1,$let2) = @_;
    my $this = {};
    bless $this,$class;

    @{$this->{BASES}} = @$bases;
    $this->{LET1} = $let1;
    $this->{LET2} = $let2;
    return $this;
}

sub IsGood
{
    my ($this) = @_;
    return scalar @{$this->{TENWORDS}} > 0;
}

sub PrintStatus
{
    my ($this) = @_;
    print "----\n";
    print "words: ",join(" -- ",@{$this->{RESULT}}),"\n";
    print "tenwords: ",join(",",@{$this->{TENWORDS}}),"\n";
}

sub Process
{
    my ($this) = @_;
    my $result = [];

    if (@{$this->{BASES}} == 0)
    {
	$this->Process10();
	if ($this->IsGood())
	{
	    $result = [ $this ];
	}
    }
    else
    {
	$result = $this->Process5();
    }
	
    return $result;
}

# there should be four words in $this->{WORDS}
# given the pairs:
# 0,1 (2,3)
# 0,2 (1,3)
# 0,3 (1,2)
# see if a,b or b,a and c,d or d,c are in %fw10
# for each such word found, put it into @{$this->{TENWORDS}}
sub Process10
{
    my ($this) = @_;
    my $w;

    my $result = [];
    if ($w = $this->IsTenWord(0,1,2,3)) { push @$result,$w; }
    if ($w = $this->IsTenWord(0,1,3,2)) { push @$result,$w; }
    if ($w = $this->IsTenWord(1,0,2,3)) { push @$result,$w; }
    if ($w = $this->IsTenWord(1,0,3,2)) { push @$result,$w; }

    if ($w = $this->IsTenWord(0,2,1,3)) { push @$result,$w; }
    if ($w = $this->IsTenWord(0,2,3,1)) { push @$result,$w; }
    if ($w = $this->IsTenWord(2,0,1,3)) { push @$result,$w; }
    if ($w = $this->IsTenWord(2,0,3,1)) { push @$result,$w; }

    if ($w = $this->IsTenWord(0,3,1,2)) { push @$result,$w; }
    if ($w = $this->IsTenWord(0,3,2,1)) { push @$result,$w; }
    if ($w = $this->IsTenWord(3,0,1,2)) { push @$result,$w; }
    if ($w = $this->IsTenWord(3,0,2,1)) { push @$result,$w; }

    @{$this->{TENWORDS}} = @$result;
}

    



# looks for 5 letter words out of %short5
# that can be made from the letters in $this->{BASES}
# and one of the first 5 letters in $this->{LET1} or 
# $this->{LET2} ... makes a new AldrigeItem for
# each such word found (culls the proper LET, removes
# the given base from BASES, and adds a record to RESULTS

sub Process5
{
    my ($this) = @_;
    my $result = [];
    
    for (my $bnum = 0 ; $bnum < @{$this->{BASES}} ; ++$bnum)
    {
	$r1 = $this->ProcessBase($bnum,1);
	$r2 = $this->ProcessBase($bnum,2);
	push @$result,@$r1;
	push @$result,@$r2;
    }

    return $result;
}

# given the base index and a code for a LET, return
# the AldrigeItems for valid words as above

sub ProcessBase
{
    my ($this,$bnum,$letid) = @_;
    my $result = [];
    my $base = $this->{BASES}->[$bnum];
    my @lar = split("",substr($this->{LET . $letid},0,5));
    
    for my $let (@lar)
    {
	my $wl = WordList($let . $base);
	for my $word (@$wl)
	{
	    my $newai = {};
	    bless $newai,ref $this;
	    @{$newai->{BASES}} = @{$this->{BASES}};
	    splice @{$newai->{BASES}},$bnum,1;
	    $newai->{LET1} = $this->{LET1};
	    $newai->{LET2} = $this->{LET2};
	    substr($newai->{LET.$letid},
		   index($newai->{LET.$letid},$let),
		   1,'');
	    @{$newai->{RESULT}} = @{$this->{RESULT}};
	    @{$newai->{WORDS}} = @{$this->{WORDS}};
	    push @{$newai->{WORDS}}, $word;
	    push @{$newai->{RESULT}},[$let,$letid,$word];
	    push @$result,$newai;
	}
    }
    return $result;
}
	    
	


1;
