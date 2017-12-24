use Crypt::Cipher::AES;

sub hextobin($)
{
	my ($input) = @_;
	my $result = "";
	
	my @iar = split(//,$input);
	for (my $i = 0 ; $i < @iar ; $i += 2)
	{
		$result .= chr(hex($iar[$i] . $iar[$i+1]));
	}
	return $result;
}
	
sub blockify($$)
{
	my ($input,$bits) = @_;
	die ("non div 8 bit length") unless ($bits % 8) == 0; 
	my $nbytes = $bits / 8;
	my @output;
	my $oidx = 0;
	my @iar = split(//,$input);
	for (my $i = 0 ; $i < @iar ; ++$i)
	{
		$output[$oidx] .= $iar[$i];
		++$oidx if ($i % $nbytes) == ($nbytes-1);
	}
	
	return @output;
}

sub bintohex($)
{
	my ($input) = @_;
	my $output = "";
	my @iar = split(//,$input);
	for (my $i = 0 ; $i < @iar ; ++$i)
	{
		$output .= sprintf("%02x",ord($iar[$i]));
	}
	return $output;
}

sub CBCdecrypt($$)
{
	my ($key,$ct) = @_;
	my @blocks = blockify($ct,128);
	my $iv = shift(@blocks);
	my $c = Crypt::Cipher::AES->new($key);
	my $result = "";
	for (my $i = 0 ; $i < @blocks ; ++$i)
	{
		my $xb = $iv;
		$xb = $blocks[$i-1] if $i > 0;
		my $pt = $c->decrypt($blocks[$i]);
		$result .= ($pt ^ $xb);
	}
	my $padcnt = ord(substr($result,-1));
	for (my $i = 0 ; $i < $padcnt ; ++$i) { chop $result; }
	return $result;
}

sub binModeIncrement($)
{
	my ($input) = @_;
	my @iar = split(//,$input);
	my $iidx = $#iar;
	while($iidx >= 0)
	{
		my $item = ord($iar[$iidx]);
		++$item;
		$item = 0 if $item > 0xff;
		$iar[$iidx] = chr($item);
		last unless $item == 0;
		--$iidx;
	}
	return join("",@iar);
}
		
sub CTRdecrypt($$)
{
	my ($key,$ct) = @_;
	my @blocks = blockify($ct,128);
	my $iv = shift(@blocks);
	my $c = Crypt::Cipher::AES->new($key);
	my $result = "";
	for (my $i = 0 ; $i < @blocks ; ++$i)
	{
		my $ptb = $blocks[$i] ^ $c->encrypt($iv);
		$result .= substr($ptb,0,length($blocks[$i]));
		$iv = binModeIncrement($iv);
	}
	return $result;
}
	


my $k1 = hextobin("140b41b22a29beb4061bda66b6747e14");
my $ct1 = hextobin("4ca00ff4c898d61e1edbf1800618fb2828a226d160dad07883d04e008a7897ee2e4b7465d5290d0c0e6c6822236e1daafb94ffe0c5da05d9476be028ad7c1d81");
my $pt1 = CBCdecrypt($k1,$ct1);

print "Q1: $pt1\n";

my $k2 = hextobin("140b41b22a29beb4061bda66b6747e14");
my $ct2 = hextobin("5b68629feb8606f9a6667670b75b38a5b4832d0f26e1ab7da33249de7d4afc48e713ac646ace36e872ad5fb8a512428a6e21364b0c374df45503473c5242a253");
my $pt2 = CBCdecrypt($k2,$ct2);

print "Q2: $pt2\n";

my $k3 = hextobin("36f18357be4dbd77f050515c73fcf9f2");
my $ct3 = hextobin("69dda8455c7dd4254bf353b773304eec0ec7702330098ce7f7520d1cbbb20fc388d1b0adb5054dbd7370849dbf0b88d393f252e764f1f5f7ad97ef79d59ce29f5f51eeca32eabedd9afa9329");
my $pt3 = CTRdecrypt($k3,$ct3);

print "Q3: $pt3\n";

my $k4 = hextobin("36f18357be4dbd77f050515c73fcf9f2");
my $ct4 = hextobin("770b80259ec33beb2561358a9f2dc617e46218c0a53cbeca695ae45faa8952aa0e311bde9d4e01726d3184c34451");
my $pt4 = CTRdecrypt($k4,$ct4);

print "Q4: $pt4\n";

