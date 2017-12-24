BEGIN { push @INC,"../common"; }

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");

while(<FD>)
{
    $_ =~ s/\r?\n$//;
    push @dnas,$_;
}
close FD;

for ($di = 0 ; $di < @dnas ; ++$di)
{
    for ($si = 0 ; $si < length($dnas[$di]) ; ++$si)
    {
	my $ch = substr($dnas[$di],$si,1);
	++$prof[$si]->{$ch};
    }
}

for ($pi = 0 ; $pi < @prof ; ++$pi)
{
    my @war = sort { $prof[$pi]->{$b} <=> $prof[$pi]->{$a} } keys %{$prof[$pi]};
    print $war[0];
}
print "\n";
for $bp (A,C,G,T)
{
    print $bp,": ";
    for ($pi = 0 ; $pi < @prof ; ++$pi)
    {
	if (exists $prof[$pi]->{$bp})
	{
	    print $prof[$pi]->{$bp}," ";
	}
	else
	{
	    print "0 ";
	}
    }
    print "\n";
}

