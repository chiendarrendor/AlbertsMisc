my @mother = (
    [6,1],
    [5,1],
    [5,2],
    [5,3],
    [4,3],
    [3,3],
    [2,3],
    [2,4],
    [3,4],
    [4,4],
    [5,4],
    [5,5],
    [4,5],
    [4,6],
    [3,6],
    [2,6],
    [1,6]
    );

my @daughter = (
    [1,6],
    [1,5],
    [2,5],
    [3,5],
    [4,5],
    [4,4],
    [4,3],
    [4,2],
    [5,2],
    [6,2],
    [6,1]
    );

my $midx = 0;
my $mdir = 1;
my $didx = 0;
my $ddir = 1;
my $sctr = 0;

while(1) {
    if ($mother[$midx]->[0] == $daughter[$didx]->[0] &&
	$mother[$midx]->[1] == $daughter[$didx]->[1]) {
	print "intersect at step $sctr, (",
	    $mother[$midx]->[0], ",",	
	$mother[$midx]->[1], ")\n";
	exit(0);
    }

    ++$sctr;

    $midx += $mdir;
    if ($midx == (@mother-1)) { $mdir = -1; }
    if ($midx == 0) { $mdir = 1; }

    $didx += $ddir;
    if ($didx == (@daughter-1)) { $ddir = -1; }
    if ($didx == 0) { $ddir = 1; }
}

