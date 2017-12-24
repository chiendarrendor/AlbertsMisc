
my $stile = [ 'x','m','m','m' ];

my @tiles = (
    [ 'm','l','r','m' ], 
    [ 'm','l','l','r' ],
    [ 'm','m','x','l' ],
    [ 'm','m','r','l' ],
    [ 'l','r','x','r' ],
    [ 'l','r','r','x' ]
    );

sub rotate
{
    my ($tile) = @_;
    my $result = [];
    for (my $i = 1 ; $i < 4 ; ++$i) {
	push @$result,$tile->[$i];
    }
    push @$result,$tile->[0];
    return $result;
}

# edges:
# 0
#3 1
# 2

# spaces:
#            C
#           B0D
#  C    B    |    D
# A1 -- 2 -- 3 -- 4A
#  E    |    F    G
#      E5F
#       G
# print cell:
#
# ...
#.   .
#.   .
#.   .
# ...
#


my @tileplacements;

sub Matches($$)
{
    my ($e1,$e2) = @_;
    die("bad edge $e1") unless $e1 =~ /^[xmlr]$/;
    die("bad edge $e2") unless $e2 =~ /^[xmlr]$/;


    return 1 if ($e1 eq 'x' && $e2 eq 'x');
    return 1 if ($e1 eq 'm' && $e2 eq 'm');
    return 1 if ($e1 eq 'l' && $e2 eq 'r');
    return 1 if ($e1 eq 'r' && $e2 eq 'l');
    return 0;
}

sub ValidatePlacements
{
    my ($depth) = @_;
    if ($depth == 1) {
	return Matches($tileplacements[0]->[0],$tileplacements[1]->[0]);
    } elsif ($depth == 2) {
	return 
	    Matches($tileplacements[0]->[3],$tileplacements[2]->[0]) &&
	    Matches($tileplacements[1]->[1],$tileplacements[2]->[3]);
    } elsif ($depth == 3) {
	return
	    Matches($tileplacements[3]->[0],$tileplacements[0]->[2]) &&
	    Matches($tileplacements[3]->[3],$tileplacements[2]->[1]);
    } elsif ($depth == 4) {
	return
	    Matches($tileplacements[4]->[0],$tileplacements[0]->[1]) &&
	    Matches($tileplacements[4]->[1],$tileplacements[1]->[3]) &&
	    Matches($tileplacements[4]->[3],$tileplacements[3]->[1]);
    } else {
	return
	    Matches($tileplacements[5]->[0],$tileplacements[2]->[2]) &&
	    Matches($tileplacements[5]->[1],$tileplacements[3]->[2]) &&
	    Matches($tileplacements[5]->[2],$tileplacements[4]->[2]) &&
	    Matches($tileplacements[5]->[3],$tileplacements[1]->[2]);
    }
}




$tileplacements[0] = $stile;

RecursePlace(1,0);


sub RecursePlace
{
    my ($curdepth,$marks) = @_;
    print "     "x$curdepth,"Depth: $curdepth  Marks: ",sprintf("%b\n",$marks);
    print "     "x$curdepth,"board: ";
    for (my $i = 0 ; $i < $curdepth ; ++$i) {
	print "[",join(",",@{$tileplacements[$i]}),"]";
    }
    print "\n";


    if ($curdepth == 6) {
	for (my $i = 0 ; $i < 6 ; ++$i) {
	    print join(",",@{$tileplacements[$i]}),"\n";
	}
	exit(0);
    }

    for (my $i = 0 ; $i < @tiles ; ++$i) {
	next if ($marks & (1<<$i));
	my $tr = rotate($tiles[$i]);
	my $nm = $marks | (1<<$i);
	for (my $j = 0 ; $j < 4 ; ++$j) {
	    $tr = rotate($tr);
	    print "     "x$curdepth,"  tile $i checking: ",join(",",@$tr),"\n";
	    $tileplacements[$curdepth] = $tr;
	    next unless ValidatePlacements($curdepth);
	    print "     "x$curdepth,"  tile $i matched: ",join(",",@$tr),"\n";
	    RecursePlace($curdepth+1,$nm);
	    $tileplacements[$curdepth] = undef;
	}
    }
}



	    
	
    
    

