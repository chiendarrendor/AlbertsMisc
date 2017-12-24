
# the output of this is a arrayref of two parts:
# [<dist , [ <changes> ] ]
# DELTAS consist of:
# 'S<char>' -- characters are identical in both
# 'I<char>' -- a character appears in $s2 that is not in $s1
# 'D<char>' -- a character appears in $s1 that is not in $s2
# 'T<char1><char2>' char is char 1 in s1, char2 in s2

sub LevenshteinDistance
{
    my ($s1,$s2) = @_;
    my %ldmemo;
    my $result = LevenshteinDistanceR(\%ldmemo,$s1,0,$s2,0);

    print "memo size: ",scalar keys %ldmemo,"\n";

    return $result;
}


sub LevenshteinDistanceR
{
    my ($ldmemo,$s1,$s1loc,$s2,$s2loc) = @_;

    if (exists $ldmemo->{$s1loc,$s2loc})
    {
	my $result = $ldmemo->{$s1loc,$s2loc};

	return $result;
    }

    my $l1 = length($s1);
    my $l2 = length($s2);

    if ($l1 == 0)
    {
	my $changes = [];
	for (my $i = 0 ; $i < $l2 ; ++$i)
	{
	    push @$changes,"I".substr($s2,$i,1);
	}

	my $result = [ $l2,$changes];
	$ldmemo->{$s1loc,$s2loc} = $result;

	return $result;
    }

    if ($l2 == 0)
    {
	my $changes = [];
	for (my $i = 0 ; $i < $l1 ; ++$i)
	{
	    push @$changes,"D".substr($s1,$i,1);
	}

	my $result = [ $l1,$changes ];
	$ldmemo->{$s1loc,$s2loc} = $result;
	return $result;
    }


    # DISTANCE = 0  DELTAS = 1  ND = 2 PREFIX = 3

    my $c1 = substr($s1,0,1);
    my $c2 = substr($s2,0,1);

    my $opt1 = LevenshteinDistanceR(
	$ldmemo,
	substr($s1,1), $s1loc + 1,
	$s2 , $s2loc,
	) ;
    $opt1->[2] = $opt1->[0]+1;
    $opt1->[3] = "D" . $c1;

    my $opt2 = LevenshteinDistanceR(
	$ldmemo,
	$s1, $s1loc,
	substr($s2,1) , $s2loc+1,
	) ;

    $opt2->[2] = $opt2->[0] + 1;
    $opt2->[3] = "I" . $c2;

    my $opt3 = LevenshteinDistanceR(
	$ldmemo,
	substr($s1,1), $s1loc+1,
	substr($s2,1), $s2loc+1,
	) ;

    if ($c1 eq $c2)
    {
	$opt3->[2] = $opt3->[0];
	$opt3->[3] = "S" . $c1;
    }
    else
    {
	$opt3->[2] = $opt3->[0] + 1;
	$opt3->[3] = "T" . $c1 . $c2;
    }

    my @opts = sort { $a->[2] <=> $b->[2] } ($opt1,$opt2,$opt3);

    my $changes = [];
    push @$changes,$opts[0]->[3];
    push @$changes,@{$opts[0]->[1]};

    my $result = [$opts[0]->[2],$changes ];


    $ldmemo->{$s1loc,$s2loc} = $result;

    return $result;

}

sub OpDelta
{
    my ($ary,$which) = @_;
    my $result = "";

    for my $i (@$ary)
    {
	my $t = substr($i,0,1);
	if ($t eq 'S') { $result .= substr($i,1,1); }
	elsif($t eq 'D')
	{
	    $result .= "-" if $which == 2;
	    $result .= substr($i,1,1) if $which == 1;
	}
	elsif($t eq 'I')
	{
	    $result .= "-" if $which == 1;
	    $result .= substr($i,1,1) if $which == 2;
	}
	else
	{
	    $result .= substr($i,1,1) if $which == 1;
	    $result .= substr($i,2,1) if $which == 2;
	}

    }

    return $result;
}


    



# ------------------ main -------------

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");
$str1 = <FD>;
$str1 =~ s/\r?\n$//;
$str2 = <FD>;
$str2 =~ s/\r?\n$//;
close FD;


my $ld = LevenshteinDistance($str1,$str2);
print $ld->[0],"\n";
print OpDelta($ld->[1],1),"\n";
print OpDelta($ld->[1],2),"\n";



    




	
