package AuctionItem;

use Utility;
use LetterManager;
use Term::ANSIColor;

# knows history
#   letter - winner - winnning word -bid
# knows pending 'guess'
# knows unused letters



sub new
{
    my ($class,$letters) = @_;
    my $this = {};
    bless $this,$class;
    $this->{LETTERS} = new LetterManager($letters);
    $this->{PATH} = [];
    return $this;
}

sub AddPending
{
    my ($this,$letter) = @_;
    $this->{LETTERS}->Remove($letter);
    $this->{PENDING} = $letter;
}

sub clone
{
    my ($this) = @_;
    my $result = {};
    bless $result,ref $this;
    $result->{PENDING} = $this->{PENDING};
    $result->{LETTERS} = $this->{LETTERS}->clone();
    @{$result->{PATH}} = @{$this->{PATH}};
    return $result;
}

sub depth
{
    my ($this) = @_;
    my $result = 1;
    my $k = $this->{LETTERS}->FullDepth();
    return 0 if $k == 0;
    return 1 if $k == 1;
    while ($k > 1) { $result *= $k ; --$k; }
    return $result;
}

# returns -1 if the chain dies.
# returns 0 if the user doesn't like it.
# returns 1 otherwise

my @priorpath;

sub ProcessPending
{
    my ($this) = @_;
    # show user path
    my $ctr = 0;
    print "Path: ";

    for (my $i = 0 ; $i < @{$this->{PATH}} ; ++$i)
    {
	my $item = $this->{PATH}->[$i];
	print "," if $ctr > 0;

	if ($i >= @priorpath) { print color 'black on_white'; }
	elsif ($item->{LETTER} ne $priorpath[$i]->{LETTER}) { print color 'black on_white'; }

	print $item->{LETTER},"->",$item->{WORD};
	print color 'reset';
	++$ctr;
    }
    print "\n";
    # prompt user with pending letter
    # get winner

    @priorpath = @{$this->{PATH}};


    # only for last stage of aldridge, we know all the words
#    my %aldridgehash = ( bA=>breed,sA=>cross,yA=>every,nA=>thing,aB=>bread,mB=>crumb,uB=>sauce,pB=>apple);
#    $word = $aldridgehash{$this->{PENDING}};
#    print "word of applying ",$this->{PENDING}," = $word\n";

    print "word of applying ",$this->{PENDING},": ";
    $word = Utility::GetUserString();

    return -1 if length($word) == 0;

    $pathitem = { LETTER=>$this->{PENDING},
		  WORD=>$word };

    push @{$this->{PATH}},$pathitem;
    delete $this->{PENDING};


    # general code
    print "continue this path? (y/n): ";
    $cont = Utility::GetUserString();

    return 0 if $cont eq 'n';

    return 1;
}
    

# returns a string of the form type:<contents>
# contents:
# PENDING:LETTERS:PATH

sub Serialize
{
    my ($this,$type) = @_;
    my $result = $type . ':';
    if (exists $this->{PENDING}) { $result .= $this->{PENDING} }
    $result .= ':';
    $result .= $this->{LETTERS}->Serialize();
    $result .= ':';
    my $first = 1;
    for my $pi (@{$this->{PATH}})
    {
	if ($first == 0) { $result .= ','; }
	$first = 0;
	$result .= $pi->{LETTER} . '^' . $pi->{WORD};
    }
    return $result;
}

# takes a string of the form type:<contents>,
# alters this class to that form, and then
# returns type
sub Deserialize
{
    my ($this,$string) = @_;
    my @dar = split(':',$string);
    my $type = $dar[0];
    if (length($dar[1]) > 0) { $this->{PENDING} = $dar[1]; }
    $this->{LETTERS} = new LetterManager($dar[2]);
    my @par = split(',',$dar[3]);
    for my $par (@par)
    {
	my @pp = split('\^',$par);
	push @{$this->{PATH}},{LETTER=>$pp[0],WORD=>$pp[1]};
    }

    return $type;
}

sub GetCanonicalKey
{
    my ($this) = @_;
    my @tar;
    for $pi (@{$this->{PATH}}) { push @tar,substr($pi->{LETTER},0,1) . '.' . $pi->{WORD}; }
    @tar = sort @tar;
    return join("/",@tar) . '^' .  $this->{LETTERS}->CanonicalKey();
}

1;
