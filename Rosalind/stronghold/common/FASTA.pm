package FASTA;

sub new
{
    my ($class,$name) = @_;
    my $this = {};
    bless $this,$class;
    $this->{NAME} = $name;
    $this->{DNA} = "";
    return $this;
}

sub AddDNA
{
    my ($this,$strand) = @_;
    $this->{DNA} .= $strand;
}

sub GetName
{
    my ($this) = @_;
    return $this->{NAME};
}

sub GetDNA
{
    my ($this) = @_;
    return $this->{DNA};
}

package FASTASET;
sub new
{
    my ($class) = @_;
    my $this = {}; 
    $this->{FASTAS} = [];
    bless $this,$class;
}

sub AddFASTAS
{
    my ($this,@lines) = @_;

    my $curfasta;
    for my $line (@lines)
    {
	$line =~ s/\r?\n$//;
	next if length($line) == 0;
	if (substr($line,0,1) eq '>')
	{
	    $curfasta = new FASTA(substr($line,1));
	    push @{$this->{FASTAS}},$curfasta;
	}
	else
	{
	    $curfasta->AddDNA($line);
	}
    }
}
	
sub GetFASTAS
{
    my ($this) = @_;
    return $this->{FASTAS};
}
    


package FASTAFILE;
BEGIN { push @ISA,qw(FASTASET); }

sub new
{
    my ($class,$filename) = @_;
    my $set = $class->SUPER::new($filename);

    open(FSFD,$filename) || die("can't open $filename\n");
    my @lar = <FSFD>;
    $set->AddFASTAS(@lar);
    close FSFD;
    return $set;
}


package FASTAURI;
use LWP;

BEGIN { push @ISA,qw(FASTASET); }

sub new
{
    my ($class,@uris) = @_;
    my $set = $class->SUPER::new($filename);

    for my $prot (@uris)
    {
	$prot =~ s/\r?\n$//;
	my $uri = "http://www.uniprot.org/uniprot/" . $prot . ".fasta";

	my $browser = LWP::UserAgent->new;
	my $response = $browser->get($uri);

	if (!$response->is_success)
	{
	    die("problem with http: " . $response->status_line );
	}
	my $content = $response->content;
	my @car = split("\r?\n",$content);
	$set->AddFASTAS(@car);
	$set->{FASTAS}->[@{$set->{FASTAS}} - 1]->{PROTNAME} = $prot;
    }

    return $set;
}

	




1;


