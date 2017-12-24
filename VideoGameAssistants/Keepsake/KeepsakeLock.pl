
# 5 tumblers, each numbered 1-5
# turning a tumbler increases its own number 1,
# and another by 2, thus:
# turn		also turn
# 1		4
# 2		3
# 3		5
# 4		2
# 5		1

# start with 11111
# find 24345

sub itum
{
	my ($str,$incidx) = @_;
	my $res = $str;
	my $item = substr($str,$incidx,1);
	++$item;
	$item = 1 if $item==6;
	substr($res,$incidx,1,$item);
	return $res;
}

sub mn
{
	my ($str,$fromloc,$toloc) = @_;
	my $fromidx = $fromloc -1;
	my $toidx = $toloc - 1;
	return itum(itum(itum($str,$fromidx),$toidx),$toidx);
}

my %predecessors; # contains string of predecessor, tumbler turned
my @queue;

push @queue,"11111";
$predecessors{"11111"} = "----- -";
while(scalar @queue)
{
	my $cur = pop @queue;
	my @nexts = ("",mn($cur,1,4),mn($cur,2,3),mn($cur,3,5),mn($cur,4,2),mn($cur,5,1));

	for (my $i = 1 ; $i <= 5 ; ++$i)
	{
		next if exists $predecessors{$nexts[$i]};
		$predecessors{$nexts[$i]} = $cur . " " . $i;
		push @queue,$nexts[$i];
	}
}

$cur = "24345";
my $res = "";
while($cur ne "-----")
{
	print $cur,": ",$predecessors{$cur},"\n";
	$res = substr($predecessors{$cur},6,1) . $res;	
	$cur = substr($predecessors{$cur},0,5);
}

print $res;


