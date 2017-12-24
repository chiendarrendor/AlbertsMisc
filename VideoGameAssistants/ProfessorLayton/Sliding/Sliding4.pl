BEGIN { push @INC,"../../Common/Perl"; }

use SlidingInfo;
use SlidingAStar;

package main;

my $si = new SlidingInfo(8,4);
$si->AddBlocker(0,0);
$si->AddBlocker(0,1);
$si->AddBlocker(7,2);
$si->AddBlocker(7,3);
$si->AddTile('B',[[0,0],[1,0],[0,1],[1,1]],0,2);
$si->AddTile('C',[[0,0],[1,0],[0,1],[1,1]],6,0);
$si->AddTile('U',[[0,0],[1,0],[0,1]],2,0);
$si->AddTile('D',[[0,0],[0,1],[-1,1]],5,2);
$si->AddTile('R',[[0,0],[1,0],[1,1]],4,0);
$si->AddTile('L',[[0,0],[0,1],[1,1]],2,2);
$si->AddGoal('C',0,2);
$si->AddGoal('B',6,0);
$si->AddGoal('U',2,0);
$si->AddGoal('D',5,2);
$si->AddGoal('L',2,2);
$si->AddGoal('R',4,0);
$si->Validate();

SlidingAStar::AStar($si,1);


