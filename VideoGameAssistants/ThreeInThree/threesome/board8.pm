$board->AddRoom("HIGH");
$board->AddRoom("UP");
$board->AddRoom("DOWN");
$board->AddRoom("LOW");
$board->AddPlayer("DOWN");
$board->AddPlayer("DOWN");
$board->AddPlayer("DOWN");
$board->AddTargetToRoom("LOW");
$board->AddTargetToRoom("LOW");
$board->AddTargetToRoom("LOW");
$board->AddColorsToRoom("HIGH","G","O","G");
$board->AddColorsToRoom("UP","B","B");
$board->AddColorsToRoom("DOWN","R","R");
$board->AddColorsToRoom("LOW","G","G");
$board->AddDoor("HIGH","UP","G","G");
$board->AddDoor("HIGH","UP","B","B");
$board->AddDoor("HIGH","UP","R","R");
$board->AddDoor("HIGH","UP","R","B");
$board->AddDoor("HIGH","UP","B","O");
$board->AddDoor("UP","DOWN","G","G");
$board->AddDoor("UP","DOWN","B","B");
$board->AddDoor("UP","DOWN","R","R");
$board->AddDoor("UP","DOWN","B","G");
$board->AddDoor("UP","DOWN","G","R");
$board->AddDoor("DOWN","LOW","G","G");
$board->AddDoor("DOWN","LOW","R","R");
$board->AddDoor("DOWN","LOW","B","B");
