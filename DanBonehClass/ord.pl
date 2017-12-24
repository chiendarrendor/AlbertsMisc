


my $r = 7;
my $b = 6;

my %vals;
my $i = 0;
while(1)
{
	my $llen = (scalar keys %vals);
	my $v = ($b ** $i) % $r;
	$vals{$v} = 1;
	my $len = (scalar keys %vals);
	print "Val: ",$v," Size: ",$len,"\n";
	++$i;
	
	last if $llen == $len;
}