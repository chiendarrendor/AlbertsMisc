use Astar;
use wordrot;
use gameinfo;

my $gi = new gameinfo(@ARGV);

my $start = new wordrot($gi);
Astar::Astar($start,1);
