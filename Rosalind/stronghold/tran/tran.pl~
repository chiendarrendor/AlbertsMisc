BEGIN {push @INC,"../common"; }

use FASTA;

sub NucleotideCount
{
    my ($strand) = @_;
    my @sar = split(//,$strand);
    my $result = {};
    for (my $i = 0 ; $i < @sar ; ++$i)
    {
	++$result->{$sar[$i]};
    }
    return $result;
}

die("bad command line\n") unless @ARGV == 1;
my $fname = $ARGV[0];

my $file = new FASTAFILE($fname);

my $bestfasta;
my $bestgc = -1;
for (my $i = 0 ; $i < @{$file->GetFASTAS()} ; ++$i)
{
    my $fasta = $file->GetFASTAS()->[$i];
    my $ncounts = NucleotideCount($fasta->GetDNA());
    my $total = $ncounts->{A} + $ncounts->{G} + $ncounts->{T} + $ncounts->{C};
    my $numer = $ncounts->{G} + $ncounts->{C};
    my $gccontent = $numer / $total * 100.0;

    if ($gccontent > $bestgc)
    {
	$bestfasta = $fasta;
	$bestgc = $gccontent;
    }
}

print $bestfasta->GetName(),"\n";
printf("%.6f%%\n",$bestgc);


