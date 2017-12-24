package GridData;

my $wordsfile = "words4";
# this class takes four four-character strings,
# builds two sets from them (upper and lower case)
# determines which matrix cells are for which set,
# and loads from 'words'

sub new
{
    my ($class,@vdata) = @_;
    my $this = {};

    bless $this,$class;
    $this->{UPPERCELLS} = [];
    $this->{LOWERCELLS} = [];
    $this->{UPPERCHARS} = [];
    $this->{LOWERCHARS} = [];
    $this->{WORDS} = [];
    
    die("bad argument list") unless @vdata == 4;

    my @allletters;
    for (my $y = 0 ; $y < 4 ; ++$y)
    {
	die("bad argument") unless $vdata[$y] =~ /^[A-Za-z]{4}$/;
	for (my $x = 0 ; $x < 4 ; ++$x)
	{
	    my $c = substr($vdata[$y],$x,1);
	    my $t = $c =~ /[A-Z]/ ? "UPPER" : "LOWER";
	    $c =~ y/A-Z/a-z/;
	    push @{$this->{$t . "CELLS"}},[$x,$y];
	    push @{$this->{$t . "CHARS"}},$c;
	    push @allletters,$c;
	}
    }
    my $reg = '\'^[' . join("",@allletters) . ']{4}$\''; # ';
    @{$this->{WORDS}} = split("\n",`grep -E $reg $wordsfile`);
    return $this;
}

# returns an arrayref to a subset of WORDS
# such that a) it matches $sword (can be used directly as a
#                                regex because missing letters
#                                are '.')
#  and that b) the letters found to replace each '.' are
#              actually present in the $unused arrayref
sub SearchWords
{
    my ($this,$sword,$unused) = @_;
    my $result = [];

    WORD: for my $word (@{$this->{WORDS}})
    {
	next unless $word =~ /^$sword$/;
	my @letar = @$unused;
	for (my $i = 0 ; $i < 4 ; ++$i)
	{
	    next if substr($sword,$i,1) ne '.';
	    my $rc = substr($word,$i,1);
	    my $j;
	    for ($j = 0 ; $j < @letar ; ++$j)
	    {
		last if $letar[$j] eq $rc;
	    }
	    next WORD if $j == @letar;
	    splice(@letar,$j,1);
	}
	push @$result,$word;
    }
    return $result;
}


1;
