BEGIN { push @INC,"../common"; }
use codon;

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
while(<FD>)
{
    $_ =~ s/\r?\n$//;
    push @spec,$_;
}
close FD;

for ($i = 0 ; $i < @spec-1 ; ++$i)
{
    push @diffs,$spec[$i+1]-$spec[$i];
}

print join("",map { codon::WeightProtein($_) } @diffs);


    


