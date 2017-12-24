BEGIN { push @INC,"../common"; }
use codon;
use DNA;

sub Process
{
    my ($str) = @_;
    my $cidx = 0;

#    print $str,"\n";

    while(1)
    {
	my $res = codon::Translate($str,$cidx);
	$orf{$res->[1]}=1 if $res->[1];
	last if $res->[0] == -1;
	$cidx = $res->[0];
    }
}




die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$str = <FD>;
close FD;
$str =~ s/\r?\n$//;

$rna = DNA::Transcribe($str);

Process($rna);
$rc = DNA::ReverseComplement($str);
$rna = DNA::Transcribe($rc);
Process($rna);

print join("\n",keys %orf),"\n";





