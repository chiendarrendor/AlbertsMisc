BEGIN { push @INC,"../common"; }
use DNA;

sub Process
{
    my ($str) = @_;
    my $len = length($str)-1;

    my $ls = substr($str,0,$len);
    my $rs = substr($str,1,$len);

    $edges{$ls . ', ' . $rs} = 1;
}


die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");

while(<FD>)
{
    $_ =~ s/\r?\n$//;
    Process($_);
    $r = DNA::ReverseComplement($_);
    Process($r);
}
close FD;

for $k (keys %edges)
{
    print '(',$k,')',"\n";
}



