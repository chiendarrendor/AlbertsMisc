use Game;

# given a list of:
# * Player/Team Name
# * Unique Character
# * Executable
# play a game between each unique pair of them,
# remembering win/loss/tie for each player.

$| = 1;

if (@ARGV != 3)
{
    die("Bad Command Line: <player file> <work dir> <game size>\n");
}

if (($ARGV[2] % 2) != 1)
{
    die("Game Size must be odd\n");
}

# set up work directory
if (-d $ARGV[1])
{
    die("Work Dir should not exist\n");
}

$workdir = $ARGV[1];
$finaldir = "$ARGV[1]/final";
$gamesize = $ARGV[2];
mkdir($workdir);
mkdir($finaldir);


open WF,$ARGV[0] || die("Can't open $ARGV[0]\n");
my %teams;
my @codes;
while(<WF>)
{
    chomp;
    $team = {};
    ($team->{CODE},$team->{NAME},$team->{EXEC}) = split(",");

    if (exists($teams{$team->{CODE}}))
    {
	die("duplicate team code $team->{CODE}\n");
    }
    $teams{$team->{CODE}} = $team;
    push @codes,$team->{CODE};
}

close(WF);

# determine each pair
# and play a game
for ($i = 0 ; $i < @codes ; ++$i)
{
    $teama = $teams{$codes[$i]};
    for ($j = $i + 1 ; $j < @codes ; ++$j)
    {
	$teamb = $teams{$codes[$j]};
	$fname = Game::PlayGame($teama,$teamb,$workdir,$gamesize);
	system("mv $fname $finaldir/$codes[$i]vs$codes[$j].txt");

	# play another game with the sides switched
	$fname = Game::PlayGame($teamb,$teama,$workdir,$gamesize);
	system("mv $fname $finaldir/$codes[$j]vs$codes[$i].txt");
    }
}

@codes = sort
{
    if ($teams{$a}->{WINS} != $teams{$b}->{WINS}) 
    { 
	return $teams{$b}->{WINS} <=> $teams{$a}->{WINS};
    }

    if ($teams{$a}->{LOSSES} != $teams{$b}->{LOSSES})
    {
	return $teams{$a}->{LOSSES} <=> $teams{$b}->{LOSSES};
    }
} @codes;

print "\n\n============================\n";
printf("%20s\t%s\t%s\t%s\n","Team Name","Wins","Ties","Losses");

for($i = 0 ; $i < @codes ; ++$i)
{
    printf("%20s\t%d\t%d\t%d\n",
	   $teams{$codes[$i]}->{NAME},
	   $teams{$codes[$i]}->{WINS},
	   $teams{$codes[$i]}->{TIES},
	   $teams{$codes[$i]}->{LOSSES});
}





