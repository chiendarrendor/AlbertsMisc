
package Permute;

# this function will return an array of
# strings that are are all permutations of the input string.

sub Permute($)
{
    my ($input) = @_;
    my @result;

    
    return @result if length($input) == 0;

    if (length($input) == 1)
    {
	push @result,$input;
	return @result;
    }

    for (my $i = 0 ; $i < length($input) ; ++$i)
    {
	my $char = substr($input,$i,1);
	my $residual = $input;
	substr($residual,$i,1,"");

	my @subperm = Permute($residual);
	for (my $j = 0 ; $j < @subperm ; ++$j)
	{
	    push @result,$char . $subperm[$j];
	}
    }
    return @result;
}

sub PermuteArray(@)
{
    my (@input) = @_;
    my @result;

    return @result if scalar @input == 0;

    if (@input == 1)
    {
	push @result,\@input;
	return @result;
    }

    for (my $i = 0 ; $i < @input ; ++$i)
    {
	my $item = $input[$i];
	my @residual = map { $_ } @input;
	splice(@residual,$i,1);

	my @subperm = PermuteArray(@residual);

	for (my $j = 0 ; $j < @subperm ; ++$j)
	{
	    my @rcopy = map {$_} @{$subperm[$j]};

	    unshift @rcopy,$item;

	    push @result,\@rcopy;
	}
    }
    return @result;
}






1;
