#BEGIN { push @INC,"../common"; }
#use codon;

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$str = <FD>;
close FD;
$str =~ s/\r?\n$//;

sub IsRevPal
{
    my ($str) = @_;
    my $rev = reverse $str;
    $rev =~ y/ATGC/TACG/;
    return $rev eq $str;
}



for ($length = 4 ; $length <= 12 ; ++$length)
{
    for ($start = 0 ; $start <= length($str) - $length ; ++$start)
    {
	my $loc = substr($str,$start,$length);
	next unless IsRevPal($loc);
	print $start+1," ",$length,"\n";
    }
}


