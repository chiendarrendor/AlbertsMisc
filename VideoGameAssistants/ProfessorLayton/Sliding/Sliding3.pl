BEGIN { push @INC,"../../Common/Perl"; }

use SlidingInfo;
use SlidingAStar;

my $si = new SlidingInfo(8,5);
$si->AddBlocker(3,1);
$si->AddBlocker(4,3);
$si->AddTile('A',[[0,0],[1,0],[2,0],[3,0]],0,0);
$si->AddTile('B',[[0,0],[1,0],[1,1]],4,0);
$si->AddTile('C',[[0,0],[1,0]],6,0,'C');
$si->AddTile('D',[[0,0],[0,1]],0,1);
$si->AddTile('E',[[0,0],[0,1],[1,0],[1,1]],1,1);
$si->AddTile('F',[[0,0],[0,1],[1,1]],4,1);
$si->AddTile('G',[[0,0],[1,0]],6,1,'C');
$si->AddTile('H',[[0,0],[1,0]],6,2,'C');
$si->AddTile('I',[[0,0],[1,0]],0,4,'C');
$si->AddTile('J',[[0,0],[1,0]],2,4,'C');
$si->AddTile('K',[[0,0],[1,0]],4,4,'C');
$si->AddTile('L',[[0,0],[1,0]],6,4,'C');
$si->AddGoal('A',4,4);
$si->Validate();

SlidingAStar::AStar($si,1);
