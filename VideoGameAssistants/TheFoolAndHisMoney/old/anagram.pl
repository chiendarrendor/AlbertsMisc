die("bad command line") unless @ARGV == 1;

sub toupper
{
    my ($c) = @_;
    $c =~ y/a-z/A-Z/;
    return $c;
}
sub tolower
{
    my ($c) = @_;
    $c =~ y/A-Z/a-z/;
    return $c;
}

my %transform;

sub FilterTransform
{
    my (@keys) = @_;
    my $result;
    my %th;
    my $key;

    for $key (@keys)
    {
	$th{$key} = 1;
    }

    for my $key (@keys)
    {
	next if $transform{$key} eq '_';
	delete $th{$transform{$key}};
    }
    return join("",sort keys %th);
}

$line = $ARGV[0];

for (my $i = 0 ; $i < length($line) ; ++$i)
{
    my $c = substr($line,$i,1);
    next unless $c =~ /[A-Za-z]/;
    $c = tolower($c);
    $transform{$c} = "_";
}

while(1)
{
    $from = "";
    $to = "";
    for $key (keys %transform)
    {
	$from .= $key;
	$from .= toupper($key);
	$to .= $transform{$key};
	$to .= toupper($transform{$key});
    }
    $nl = $line;
    eval("\$nl =~ y/$from/$to/");
    print $line,"     ",join("",sort keys %transform),"\n";
    print $nl,"     ",FilterTransform(sort keys %transform),"\n";
    $ans = <STDIN>;
    chomp $ans;
    next unless length($ans) == 2;
    $f = tolower(substr($ans,0,1));
    $t = tolower(substr($ans,1,1));
    $transform{$f} = $t;
}

	
