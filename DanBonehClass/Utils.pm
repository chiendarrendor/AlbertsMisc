package Utils;

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


1;

