$board->AddRoom("TLEFT");
$board->AddRoom("BLEFT");
$board->AddTargetToRoom("BLEFT");
$board->AddPlayer("TLEFT");
$board->AddColorToRoom("TLEFT","G");
$board->AddColorToRoom("BLEFT","B");
$board->AddDoor("TLEFT","BLEFT","R","R");
$board->AddDoor("TLEFT","BLEFT","O","R");

$board->AddRoom("TCENTER");
$board->AddRoom("BCENTER");
$board->AddTargetToRoom("BCENTER");
$board->AddPlayer("TCENTER");
$board->AddColorToRoom("TCENTER","R");
$board->AddColorToRoom("BCENTER","O");
$board->AddDoor("TCENTER","BCENTER","G","B");
$board->AddDoor("TCENTER","BCENTER","B","B");

$board->AddRoom("TRIGHT");
$board->AddRoom("BRIGHT");
$board->AddTargetToRoom("BRIGHT");
$board->AddPlayer("TRIGHT");
$board->AddColorToRoom("TRIGHT","R");
$board->AddColorToRoom("TRIGHT","G");
$board->AddColorToRoom("BRIGHT","O");
$board->AddColorToRoom("BRIGHT","B");
$board->AddDoor("TRIGHT","BRIGHT","G","O");
