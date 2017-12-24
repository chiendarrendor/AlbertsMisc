use Astar;
use RearState;

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");

$lc = 0;
while(<FD>)
{
    $_ =~ s/\r?\n//;
    next unless length($_) > 0;
    @lar = split(" ",$_);
    if ($lc % 2 == 0)
    {
	$ci = [];
	@{$ci->[0]} = @lar;
    }
    else
    {
	@{$ci->[1]} = @lar;
	push @sets,$ci;
    }
    ++$lc;
}
close(FD);


for $ci (@sets)
{
    print "------\n";
    $rs = new RearState($ci->[0],$ci->[1]);
    @result = Astar::Astar($rs,0);

    my $minlength = 1000;
    for $r (@result)
    {
	next unless $r->{ISSOLUTION};
	if ($minlength > @{$r->{PATH}})
	{
	    $minlength = @{$r->{PATH}};
	}
    }

    push @vnums,$minlength - 1;
}
print join(" ",@vnums),"\n";

