BEGIN { push @INC,"../common"; }
use codon;

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$taxa = <FD>;
$taxa =~ s/\r?\n$//;
@taxa = split(" ",$taxa);

sub MakePairs
{
    my (@pairtaxa) = @_;
    my @result;
    for (my $i = 0 ; $i < @pairtaxa ; ++$i)
    {
	for (my $j = $i+1 ; $j < @pairtaxa ; ++$j)
	{
	    my $p = [ $pairtaxa[$i] , $pairtaxa[$j] ];
	    push @result,$p;
	}
    }
    return @result;
}

my %seenbefore;

sub MakeQuartets
{
    my ($charset) = @_;
    my @charset = split("",$charset);
    my @split0;
    my @split1;
    
    for (my $i = 0 ; $i < @charset ; ++$i)
    {
	push @split0,$taxa[$i] if $charset[$i] eq '0';
	push @split1,$taxa[$i] if $charset[$i] eq '1';
    }
    my @pairs0 = MakePairs(@split0);
    my @pairs1 = MakePairs(@split1);
    
    for my $p0 (@pairs0)
    {
	for my $p1 (@pairs1)
	{
	    my @sar = ($p0->[0],$p0->[1],$p1->[0],$p1->[1]);
	    @sar = sort @sar;
	    $k = join("--",@sar);
	    
	    if (exists $seenbefore{$k})
	    {
		next;
	    }

	    $seenbefore{$k} = 1;

	    print "{" , $p0->[0] , ", " , $p0->[1] , "} {",
	                 $p1->[0] , ", " , $p1->[1] , "}\n";

	}
    }
}

while(<FD>)
{
    $_ =~ s/\r?\n$//;
    MakeQuartets($_);
}
close FD;


