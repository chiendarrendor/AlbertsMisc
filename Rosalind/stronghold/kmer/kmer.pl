BEGIN {push @INC,"../common"; }
use FASTA;

@symbols = ('A','C','G','T');
$scount = scalar @symbols;
$count = 4;

my $ocount = $scount ** $count;

for ($i = 0 ; $i < $count ; ++$i) { push @indices,0; }

for ($i = 0 ; $i < $ocount ; ++$i)
{
    my $str = "";
    for ($j = 0 ; $j < @indices ; ++$j) 
    {
	$str .= $symbols[$indices[$j]];
    }
    $kmers{$str} = 0;


    my $ci = $count-1;
    while(1)
    {
	++$indices[$ci];
	last unless $indices[$ci] == @symbols;
	$indices[$ci] = 0;
	--$ci;
    }
}

    










die("bad command line\n") unless @ARGV == 1;
my $fname = $ARGV[0];

my $file = new FASTAFILE($fname);

my $width = 4;

my $dna = $file->GetFASTAS()->[0]->GetDNA();
for ($i = 0 ; $i < length($dna) - $width + 1 ; ++$i)
{
    ++$kmers{substr($dna,$i,$width)};
}

for $kmer (sort keys %kmers)
{
    print $kmers{$kmer}," ";
}
print "\n";

