$board->AddRoom("UR");
$board->AddColorsToRoom("UR","G","G","K");
$board->AddPlayer("UR");
$board->AddPlayer("UR");
$board->AddPlayer("UR");
$board->AddRoom("LR");
$board->AddColorsToRoom("LR","R","O","K","K");
$board->AddTargetToRoom("LR");
$board->AddTargetToRoom("LR");
$board->AddTargetToRoom("LR");
$board->AddRoom("LFT");
$board->AddColorsToRoom("LFT","G","B","R","O");
$board->AddRoom("TWN");
$board->AddDoor("UR","LR","G","G");
$board->AddDoor("UR","LFT","G","G");
$board->AddDoor("LFT","LR","R","O");
$board->AddDoor("LFT","LR","K","K");
$board->AddDoor("LFT","TWN","O","R");
$board->AddDoor("TWN","UR","G","B");
