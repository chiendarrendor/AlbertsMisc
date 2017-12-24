package gameinfo;

# argument list:
# caf uom ger zea ica lro ypm forecrm 03 14 25 36 12 34 56 06
# processing:
# 1) length of first argument is ROTWIDTH
# 2) process arguments into LETTERS until one is not ROTWIDTH
# 3) next argument becomes INITIAL
#    a) must be exactly as long as the length of LETTERS
#    b) each letter must be one of the letters in corresponding LETTERS
# 4) process all remaining arguments into ACTORS
#    a) each number processed must be a valid index into LETTERS
#
# 5) use LETTERS to build a grep string, and execute it
# 6) print grep result and prompt user for target string
# 7) decode user prompt a la #3 into GOAL

sub new
{
    my ($class,@ARGV) = @_;
    my $this = {};
    bless $this,$class;

    die("bad empty command line") unless @ARGV;
    $this->{ROTWIDTH} = length($ARGV[0]);

    $this->{LETTERS} = [];
    while(@ARGV > 0 && length($ARGV[0]) == $this->{ROTWIDTH})
    {
	push @{$this->{LETTERS}},shift @ARGV;
    }
    die("bad missing initial state") unless @ARGV;

    $this->{INITIAL} = [];
    $this->BreakoutLetters($this->{INITIAL},shift @ARGV);

    $this->{ACTORS} = [];
    die("bad missing actors") unless @ARGV;
    while(@ARGV > 0)
    {
	my $actstring = shift @ARGV;
	my $act = [];
	push @{$this->{ACTORS}},$act;
	for (my $i = 0 ; $i < length($actstring) ; ++$i)
	{
	    my $ss = substr($actstring,$i,1);
	    die("bad actor") if $ss >= $this->GetLetterCount();
	    push @$act,$ss;
	}
    }

    my $gstring = '\'^';
    for my $letter (@{$this->{LETTERS}})
    {
	$gstring .= '[' . $letter . ']';
    }
    $gstring .= '$\''; # ';

    print "possible goals:\n";
    system("grep -E $gstring words");

    print "goal: ";
    my $goalstring = <STDIN>;
    chomp $goalstring;

    $this->{GOAL} = [];
    $this->BreakoutLetters($this->{GOAL},$goalstring);

    return $this;
}

sub GetLetterCount
{
    my ($this) = @_;
    return scalar @{$this->{LETTERS}};
}

sub GetLetter
{
    my ($this,$idx) = @_;
    return $this->{LETTERS}->[$idx];
}

sub GetInitial
{
    my ($this,$idx) = @_;
    return $this->{INITIAL}->[$idx];
}

sub GetGoal
{
    my ($this,$idx) = @_;
    return $this->{GOAL}->[$idx];
}

sub GetNumActors
{
    my ($this) = @_;
    return scalar @{$this->{ACTORS}};
}

sub GetActor
{
    my ($this,$idx) = @_;
    return $this->{ACTORS}->[$idx];
}

sub GetRotationWidth
{
    my ($this) = @_;
    return $this->{ROTWIDTH};
}

sub BreakoutLetters
{
    my ($this,$breakref,$string) = @_;
    die("breakout not right size") unless length($string) == $this->GetLetterCount();
    
    for (my $i = 0 ; $i < length($string) ; ++$i)
    {
	my $idx = index($this->{LETTERS}->[$i],substr($string,$i,1));
	die("bad character in breakout") if $idx == -1;
	push(@$breakref,$idx);
    }
}

1;
