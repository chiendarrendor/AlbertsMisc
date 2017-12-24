BEGIN { push @INC,"../common"; }
use Newick;

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");

$lc = 0;
while(<FD>)
{
    $_ =~ s/\r?\n//;
    next unless length($_) > 0;
    if ($lc % 2 == 0)
    {
	$ci = [];
	$ci->[0] = $_;
    }
    else
    {
	$ci->[1] = $_;
	push @sets,$ci;
    }
    ++$lc;
}
close(FD);


for $ci (@sets)
{
    my $t = new Newick($ci->[0]);

    my @fromto = split(" ",$ci->[1]);
    push @result,$t->CalculateDistance($fromto[0],$fromto[1]);

#    for $n (keys %{$t->{NODES}})
#    {
#	$node = $t->{NODES}->{$n};
#	print $n,"(",$node->{DISTANCE},"): ";
#	for $er (@{$node->{NEIGHBORS}})
#	{
#	    print $er->[0]->{NAME},"(",$er->[1],") ";
#	}
#	print "\n";
#    }
#    print "------\n";

}


print join(" ",@result),"\n";




