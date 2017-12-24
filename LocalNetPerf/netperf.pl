my @hosts = (
	"8.8.8.8",
	"yahoo.com",
	"192.168.1.1",
	"routerlogin.com",
	"192.168.100.1"
);

my @headers = (
	"Google DNS IP",
	"Yahoo Hostname",
	"Router IP",
	"Router Hostname",
	"Modem IP"
);

my $datafilename = "netperf.csv";
my $timeout = 1500;
my $sleep = 5;

sub WriteLine($)
{
	my ($data) = @_;
	
	open(my $fh,">>",$datafilename);
	print $fh $data,"\n";
	close $fh;
}

sub DoPing($)
{
	my ($hostname) = @_;
	
	my $res = `ping -n 1 -w $timeout $hostname`;
	my @reslines = split("\n",$res);
	# expect that either we should see one line of the form
	# 'Reply from <ip>: bytes=32 time=2ms TTL=64'
	# or
	# 'Request timed out.'
	my $rtt = 99999; # sentinel for no ping data
	for my $line (@reslines)
	{
		if ($line =~ /Destination net unreachable/)
		{
			$rtt = 9999;
			last;
		}
		if ($line =~ /^Request timed out./)
		{
			$rtt = 9999; # sentinel for timeout
			last;
		}
		
		if ($line =~ /^Ping request could not find host/)
		{
			$rtt = 9999;
			last;
		}
		
		if ($line =~ /^Reply from [A-Za-z0-9.]+: bytes=\d+ time=(\d+)ms/)
		{
			$rtt = $1;
			last;
		}
	}
	return $rtt;
}
		
if (! -e $datafilename)
{
	WriteLine("SSEpoch," . join(",",@headers));
}

while(1)
{
	my @pingar;

	for $h (@hosts)
	{
		push @pingar,DoPing($h);
	}
	
	WriteLine(time() . "," . join(",",@pingar));
	
	sleep($sleep);
}


		
	
	