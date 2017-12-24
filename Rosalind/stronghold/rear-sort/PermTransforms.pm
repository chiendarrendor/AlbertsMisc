package PermTransforms;
my @factorial = (1,1,2,6,24,120,720,5040,40320,362880,3628800);
my @perm0 = (1,2,3,4,5,6,7,8,9,10);
#my @perm0 = (1,2,3,4,5);

sub Width
{
    return scalar @perm0;
}

sub PermToId
{
    my ($perm) = @_;
    my @p0 = @perm0;
    my @perm = @$perm;

    die("what? PTI") unless @perm == @p0;
    return PermToIdR(\@perm,\@p0);
}


sub PermToIdR
{
    my ($perm,$p0) = @_;
    return 0 unless @$perm > 1;
    my $blockwidth = $factorial[@$perm - 1];
    my $i;
    for ($i = 0 ; $i < @$p0 ; ++$i)
    {
	last if $perm->[0] == $p0->[$i];
    }
    die("mrrr? PTI") unless $i < @$p0;

    shift @$perm;
    splice(@$p0,$i,1);
    return $i * $blockwidth + PermToIdR($perm,$p0);
}

sub IdToPerm
{
    my ($id) = @_;
    return IdToPermR($id,\@perm0);
}

sub IdToPermR
{
    my ($id,$p0)  = @_;
    my @result;

    if (@$p0 == 1)
    {
	push @result,$p0->[0];
	return @result;
    }
    
    my $blockwidth = $factorial[@$p0 - 1];
    my @next = @$p0;

    my $n;
    {
	use integer;
	$n = $id / $blockwidth;
    }

    push @result,$p0->[$n];
    splice(@next,$n,1);

    push @result,IdToPermR($id - ($n * $blockwidth),\@next);
    return @result;
}

    
    
    
    



1;
