
BEGIN { push @INC,"../common"; }
use FASTA;



die("bad command line\n") unless @ARGV == 1;
open(FD,$ARGV[0]) || die("Can't open file");
@prots = <FD>;
close FD;

my $file = new FASTAURI(@prots);

$fref = $file->GetFASTAS();
for $fasta (@$fref)
{
    my @matches = ();
    my $str = $fasta->GetDNA();
    my $prelen = 0;

    while(1)
    {
	last unless $str =~ /N[^P][ST][^P]/;
	my $ml = $-[0];
	$str = substr($str,$ml+1);
	push @matches,$-[0]+1+$prelen;
	$prelen += $ml+1;
    }
    next unless @matches;


    print $fasta->{PROTNAME},"\n";
    print join(" ",@matches),"\n";
}




