die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
while(<FD>)
{
    $_ =~ s/\r?\n$//;
    push @taxa,$_;
}
close FD;

my $width = length($taxa[0]);


for (my $i = 0 ; $i < $width ; ++$i)
{
    my %split = ();

    for (my $j = 0 ; $j < @taxa ; ++$j)
    {
	push @{$split{substr($taxa[$j],$i,1)}} , $j;
    }

    @keys = keys %split;

    die("not characterizable") if @keys > 2;
    next if @keys == 1;
    next if @{$split{$keys[0]}} == 1 || @{$split{$keys[1]}} == 1;

    my $result = "0" x scalar @taxa ;
    
    for $t (@{$split{$keys[0]}})
    {
	substr $result,$t,1,"1";
    }
    print $result,"\n";
}

