
$commands = $ARGV[0];
$mycode = $ARGV[1];
$boardfile = $ARGV[2];
$workdir = $ARGV[3];

$countfile = "$workdir/count.txt";

$count = 0;
if (-f "$countfile")
{
    open CF,"<$countfile";
    $line = <CF>;
    chomp $line;
    $count = $line;
    close CF;
}

print substr($commands,$count,1),"\n";

open CF,">$countfile";
print CF ($count+1),"\n";
close CF;

	
