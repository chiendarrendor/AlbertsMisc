$cth = "6c73d5240a948c86981bc294814d";
$pt = "attack at dawn";
$ptp = "attack at dusk";

sub stringtonumarray($)
{
	my ($str) = @_;
	my @result;
	for ($i = 0 ; $i < length($str) ; ++$i)
	{
		$result[$i] = ord(substr($str,$i,1));
	}
	return @result;
}

sub numarrayprinthex($;$)
{
	my ($array,$sep) = @_;
	my $first = 1;
	for (my $i = 0 ; $i < @$array ; ++$i)
	{
		unless ($first)
		{
			print $sep;
		}
		$first = 0;
		printf("%02x",$array->[$i]);
	}
	print "\n";
}

sub myxor($$)
{
	my ($ar1,$ar2) = @_;
	my @result;
	for (my $i = 0 ; $i < @$ar1 ; ++$i)
	{
		$result[$i] = $ar1->[$i] ^ $ar2->[$i];
	}
	return @result;
}

for ($i = 0 ; $i < length($cth) ; $i += 2)
{
	$cta[$i/2] =  hex(substr($cth,$i,2));
}

@pta = stringtonumarray($pt);
@ptpa = stringtonumarray($ptp);
numarrayprinthex(\@cta);
numarrayprinthex(\@cta,",");
numarrayprinthex(\@pta,",");

die("length mismatch") unless @cta == @pta;

@keya = myxor(\@cta,\@pta);

numarrayprinthex(\@keya,",");

@ctagain = myxor(\@pta,\@keya);
numarrayprinthex(\@ctagain,",");

@ctprime = myxor(\@ptpa,\@keya);
numarrayprinthex(\@ctprime,",");
numarrayprinthex(\@ctprime);


