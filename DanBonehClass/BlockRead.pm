package BlockRead;

sub BlockRead($$)
{
	my ($fname,$blocksize) = @_;
	
	my $buffer = "";
	my @result;
	
	open(FD,"<",$fname) || die ("Can't open file for read\n");
	while(read(FD,$buffer,$blocksize,0))
	{
		push @result,$buffer;
	}
	close(FD);
	return @result;
}
		



1;