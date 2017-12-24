use m_puzzle;
use Astar;

# letters array contains the letters available at each position
# initial is indices into letters array for the starting position
# goal is indices into letters array for the terminal position
# actors is an array of anonymous arrays, each containing the 'actors'
#   or buttons pressable. each array contains the indices into
#   letters that that button rotates
# rotwidth is the with of each string in the letters array

die("bad command line\n") if (@ARGV != 1);

if ($ARGV[0] eq 'moxley')
{
    @letters=("bde","aiu","lrf","gno","iec","nsa","tme");
    @initial=(   1,  1,     0,    2,    0,    2,    2);
    @goal=   (   2,  0,     1,    1,    1,    1,   0);
    @actors=([0,1],[1,2],[2,3],[3,6],[0,6],[3,4],[4,5],[5,6]);
    $rotwidth = 3;
}
elsif($ARGV[0] eq 'mcgucken1')
{
    @letters=("mcf","oie","vin","rid","ulc","nku","sey");
    @initial=(   0,  0,     0,    0,    0,    0,    0);
    @goal=   (   2,  1,     2,    1,    2,    1,   2);
    @actors = ([0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[1,5],[2,4]);
    $rotwidth = 3;
}
elsif($ARGV[0] eq 'mcgucken2')
{
    @letters=("cgm","oae","tvi","edr","ule","unp","ems");
    @initial=(   0,  0,     0,    0,    0,    0,    0);
    @goal=   (   2,  1,     2,    1,    2,    1,   2);
    @actors = ([2,4],[1,5],[0,6],[1,6],[2,6],[3,6],[4,6],[5,6]);
    $rotwidth = 3;
}
elsif($ARGV[0] eq 'massey1')
{
    @letters=("csf","lmt","rua","ead","ier","srn","ytm");
    @intials=(0    ,0    ,0    ,0,    0,     0,    0);
    @goal=   (1,    2,    ,1,   2,    1,     2,    1);
    @actors = ([0,2],[1,3],[2,4],[3,5],[4,6],[0,3],[3,6],[0,6]);
    $rotwidth = 3;
}
elsif($ARGV[0] eq 'massey2')
{
    @letters=("caf","uom","ger","zea","ica","lro","ypm");
    @intials=(0    ,0    ,0    ,0,    0,     0,    0);
    @goal=   (2    ,1    ,2    ,1,    2,     1,    2);
    @actors=([0,3],[1,4],[2,5],[3,6],[1,2],[3,4],[5,6],[6,0]);
    $rotwidth = 3;
}
elsif($ARGV[0] eq 'massey3')
{
    @letters=("bca","mul","gea","zia","cri","sol","nyp");
    @intials=(0    ,0    ,0    ,0,    0,     0,    0);
    @goal=   (1    ,2    ,1    ,2,    1,     2,    1);
    @actors=([0,4],[1,5],[2,6],[0,3],[1,4],[2,5],[3,6],[2,4]);
    $rotwidth = 3;
}
else
{
    die("unknown puzzle name!\n");
}


GameState::SetProperties(\@letters,\@initial,\@goal,\@actors,$rotwidth);
my $start = new GameState();
Astar::Astar($start,1);
