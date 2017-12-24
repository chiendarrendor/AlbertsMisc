BEGIN {push @INC,"../common"; }

use FASTA;

sub PDistance
{
    my ($f1,$f2) = @_;
    my $d1 = $f1->GetDNA();
    my $d2 = $f2->GetDNA();

    my $dcount = 0;
    for (my $i = 0 ; $i < length($d1) ; ++$i)
    {
	++$dcount unless substr($d1,$i,1) eq substr($d2,$i,1);
    }

    my $result = $dcount / length($d1);
    return $result;
    
}


die("bad command line\n") unless @ARGV == 1;
my $fname = $ARGV[0];

my $file = new FASTAFILE($fname);
my $ffs = $file->GetFASTAS();

for $f1 (@$ffs)
{
    for $f2 (@$ffs)
    {
	printf("%.2f ",PDistance($f1,$f2));
    }
    print "\n";
}





