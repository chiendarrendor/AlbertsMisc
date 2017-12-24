
package main;
sub asin { atan2($_[0], sqrt(1 - $_[0] * $_[0])) }
sub acos { atan2( sqrt(1 - $_[0] * $_[0]), $_[0] ) }


my $pi = 4 * atan2(1,1);



package Point;

sub new
{
    my ($class,$x,$y) = @_;
    my $this = {};
    bless $this,$class;
    $this->{X} = $x;
    $this->{Y} = $y;
    return $this;
}

package Line;

sub new
{
    my ($class,$p1,$p2) = @_;
    my $this = {};
    bless $this,$class;
    $this->{P1} = $p1;
    $this->{P2} = $p2;
    return $this;
}

sub dotProduct
{
    my ($this,$other) = @_;

    $tx =  $this->{P1}->{X} - $this->{P2}->{X};
    $ty =  $this->{P1}->{Y} - $this->{P2}->{Y};

    $ox =  $other->{P1}->{X} - $other->{P2}->{X};
    $oy =  $other->{P1}->{Y} - $other->{P2}->{Y};

    return $tx * $ox + $ty * $oy;
}

sub magnitude
{
    my ($this) = @_;
    my $xdiff = $this->{P1}->{X} - $this->{P2}->{X};
    my $ydiff = $this->{P1}->{Y} - $this->{P2}->{Y};
    

    return sqrt($xdiff * $xdiff + $ydiff * $ydiff);
}

package Ray;

sub new
{
    my ($class,$point,$angle) = @_;
    my $this = {};
    bless $this,$class;
    $this->{POINT} = $point;
    $this->{ANGLE} = $angle;
    return $this;
}

sub Intersect
{
    my ($r1,$r2) = @_;

    if ($r1->{ANGLE} == $r2->{ANGLE})
    {
	return undef;
    }

    ## line 1
    my $x1 = $r1->{POINT}->{X};
    my $y1 = $r1->{POINT}->{Y};
    my $t1 = $r1->{ANGLE} * $pi / 180;
    my $x2 = $x1 + 1;
    my $y2 = $y1 + sin($t1) / cos($t1);

    ## line 2;
    my $x3 = $r2->{POINT}->{X};
    my $y3 = $r2->{POINT}->{Y};
    my $t2 = $r2->{ANGLE} * $pi / 180;
    my $x4 = $x3 + 1;
    my $y4 = $y3 + sin($t2) / cos($t2);

    my $a1 = $y2 - $y1;
    my $b1 = $x1 - $x2;
    my $c1 = $x2 * $y1 - $x1 * $y2;

    my $a2 = $y4 - $y3;
    my $b2 = $x3 - $x4;
    my $c2 = $x4 * $y3 - $x3 * $y4;
    my $denom = $a1 * $b2 - $a2 * $b1;

    my $x = ($b1 * $c2 - $b2 * $c1) / $denom;
    my $y = ($a2 * $c1 - $a1 * $c2) / $denom;
    return new Point($x,$y);
}


package main;

sub calcangle
{
    my ($leg1,$c,$leg2) = @_;
    my $line1 = new Line($leg1,$c);
    my $line2 = new Line($leg2,$c);
    my $hyp = new Line($leg1,$leg2);
    my $l1 = $line1->magnitude;
    my $l2 = $line2->magnitude;
    my $h = $hyp->magnitude;

    return acos(($l1 * $l1 + $l2 * $l2 - $h * $h) / ( 2 * $l1 * $l2)) * 180 / $pi;
}

my %points;

sub printSide
{
    my ($p1,$p2) = @_;
    my $line = new Line($points{$p1},$points{$p2});

    printf("  %s%s %.5g\n",$p1,$p2,$line->magnitude);
}

sub printAngle
{
    my ($p1,$p2,$p3) = @_;
    printf("  %s%s%s %.5g\n",$p1,$p2,$p3,,calcangle($points{$p1},$points{$p2},$points{$p3}));
}


sub triangleinfo
{
    my ($points) = @_;
    my @pary;
    @pary = split(//,$points);

    print "triangle: $points\n";

    # sides
    # 0 1
    printSide($pary[0],$pary[1]);
    # 1 2
    printSide($pary[1],$pary[2]);
    # 0 2
    printSide($pary[0],$pary[2]);

    # angles
    # 1 0 2
    printAngle($pary[1],$pary[0],$pary[2]);
    # 0 1 2
    printAngle($pary[0],$pary[1],$pary[2]);
    # 0 2 1
    printAngle($pary[0],$pary[2],$pary[1]);
}

$points{'A'} = new Point(0,0);
$points{'B'} = new Point(100,0);

my $ac = new Ray($points{'A'},80);
my $bc = new Ray($points{'B'},100);
$points{'C'} = Ray::Intersect($ac,$bc);
my $bd = new Ray($points{'B'},120);
$points{'D'} = Ray::Intersect($ac,$bd);
my $ae = new Ray($points{'A'},70);
$points{'E'} = Ray::Intersect($ae,$bc);
$points{'Q'} = Ray::Intersect($ae,$bd);

foreach my $key (sort keys %points)
{
    print $key,": (",$points{$key}->{X},",",$points{$key}->{Y},")\n";
}

triangleinfo("ABC");
triangleinfo("AQB");
triangleinfo("AQD");
triangleinfo("BQE");
triangleinfo("ABE");
triangleinfo("ACE");
triangleinfo("ABD");
triangleinfo("BDC");
triangleinfo("CDE");
triangleinfo("BDE");
triangleinfo("ADE");
triangleinfo("DQE");
