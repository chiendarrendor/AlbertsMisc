BEGIN { push @INC,"../common"; }
use DNA;

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
while(<FD>)
{
    $_  =~ s/\r?\n$//;
    $r = DNA::ReverseComplement($_);

    if (!exists $read{$_} && !exists $read{$r})
    {
	$read{$_} = 1;
    }
    elsif (exists $read{$_})
    {
	++$read{$_};
    }
    elsif (exists $read{$r})
    {
	++$read{$r};
    }
}
close FD;

sub SingleHammingMutation
{
    my ($a,$b) = @_;
    my $count = 0;
    for (my $i = 0 ; $i < length($a) ; ++$i)
    {
	++$count if substr($a,$i,1) ne substr($b,$i,1);
	last if $count > 1;
    }
    return $count == 1;
}


for $k (keys %read)
{
    $r = DNA::ReverseComplement($k);
    print "K: $k R: $r\n";
    if ($read{$k} == 1)
    {
	push @slaves,$k;
    }
    else
    {
	push @masters,$k;
	push @masters,$r;
    }
}
print "Slaves: ",join(",",@slaves),"\n";
print "Masters: ",join(",",@masters),"\n";



for $slave (@slaves)
{
    for $master (@masters)
    {
	if (SingleHammingMutation($slave,$master))
	{
	    print $slave,"->",$master,"\n";
	    last;
	}
    }
}

		





