
$board->AddRoom("1");
$board->AddRoom("2");
$board->AddRoom("3");
$board->AddRoom("4");
$board->AddRoom("5");
$board->AddRoom("6");
$board->AddRoom("7");
$board->AddRoom("8");
$board->AddRoom("9");
$board->AddRoom("10");
$board->AddDoor("1","2","red","red");
$board->AddDoor("2","4","red","red");
$board->AddDoor("2","3","red","red");
$board->AddDoor("4","5","red","red");
$board->AddDoor("5","6","red","red");
$board->AddDoor("3","7","red","red");
$board->AddDoor("3","8","red","red");
$board->AddDoor("9","10","red","red");

$board->AddTargetToRoom("9");
$board->AddTargetToRoom("9");
$board->AddTargetToRoom("7");

$board->AddPlayer("10");
$board->AddPlayer("4");
$board->AddPlayer("10");

$board->AddColorToRoom("10","red");
$board->AddColorToRoom("10","green");
$board->AddColorToRoom("10","blue");

$board->AddDoor("10","9","X","X");


my $state = new State($board);

print "CK: ",$state->CanonicalKey(),"\n";
print "DS: ",$state->DisplayString(),"\n";
print "WG: ",$state->WinGrade(),"\n";
print "GR: ",$state->Grade(),"\n";

my @successors = $state->Successors();

print "Successors: \n";

for ($i = 0 ; $i < @successors ; $i++ )
{
    print $successors[$i]->DisplayString(),": ",$successors[$i]->Move(),"\n";
}

