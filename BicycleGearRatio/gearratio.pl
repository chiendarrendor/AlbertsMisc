
my @frontgears = (28,38,49);
my @backgears = (32,26,21,18,16,14,12,11);


for ($i = 0 ; $i < @frontgears ; $i++)
{
    for ($j = 0 ; $j < @backgears ; $j++)
    {
	$new = {};
	$new->{FRONT} = $i+1;
	$new->{BACK} = $j+1;
	$new->{RATIO} = $frontgears[$i] / $backgears[$j];
	
	push(@gears,$new);
    }
}

@gears = sort { $b->{RATIO} <=> $a->{RATIO} } @gears;

# 60 rev / min * 60 min / hr * 2130 mm / rev * 1 in / 25.4 mm 
# * 1 ft / 12 in * 1 mil / 5280 ft




$v = 80 * 60 * 2130 / 25.4 / 12 / 5280;

print "Front,back    Speed at 80rpm       ratio\n";


for ($i = 0 ; $i < @gears ; $i++)
{
    print $gears[$i]->{FRONT},",",$gears[$i]->{BACK};

    print "    ",$v * $gears[$i]->{RATIO},"    ";
    print "   ",$gears[$i]->{RATIO},"\n";
}

