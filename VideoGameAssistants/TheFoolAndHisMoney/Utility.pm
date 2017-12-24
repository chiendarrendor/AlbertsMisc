package Utility;

sub PermuteArray
{
    my ($aref) = @_;
    return [] if (@$aref == 0);
    return [$aref] if (@$aref == 1);
    my $result = [];
    for (my $i = 0 ; $i < @$aref ; ++$i)
    {
	my @tar = @$aref;
	splice(@tar,$i,1);
	my $resref = PermuteArray(\@tar);
	for my $subref (@$resref)
	{
	    my $nar = [$aref->[$i]];
	    push @$nar,@$subref;
	    push @$result,$nar;
	}
    }
    return $result;
}
    
sub GetUserString
{
    my $lin = <STDIN>;
    $lin =~ s/\r?\n$//;
    return $lin;
}


1;
