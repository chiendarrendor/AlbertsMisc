@controls = 
(
 [ "YYOOROOOO","YOOROOBOO","YOYOOOOBO","OOOOOOOOO" ],
 [ "OYORROOOO","OYYOOOOOO","OOYROOOBO","OOOOOOOOO" ],
 [ "OOOOORBOB","OOYOOOOBO","OYOOOOOOB","OOOOOOOOO" ],
 [ "OOORRROOO","OOOOOOBBB","YYYOOOOOO","OOOOOOOOO" ]
);

sub line1
{
    my ($str) = @_;
    return "   " . substr($str,0,1) . "   ";
}

sub line2
{
    my ($str) = @_;
    return "  "  . substr($str,1,1) . " " . substr($str,2,1) . "  ";
}

sub line3
{
    my ($str) = @_;
    return " " . substr($str,3,1) . "   " . substr($str,6,1) . " ";
}

sub line4
{
    my ($str) = @_;
    return substr($str,4,1) . " " . substr($str,5,1) . " " . substr($str,7,1) . " " . substr($str,8,1);
}

for($i = 0 ; $i < 4 ; ++$i)
{
    $con[0] = $controls[0]->[$i];
    for ($j = 0; $j < 4 ; ++$j)
    {
	$con[1] = $controls[1]->[$j];
	for ($k = 0 ; $k < 4 ; ++$k)
	{
	    $con[2] = $controls[2]->[$k];
	    for ($l = 0 ; $l < 4 ; ++$l)
	    {
		$con[3] = $controls[3]->[$l];
		
		$res = "";
		for ($v = 0 ; $v < 9 ; ++$v)
		{
		    $char = "O";
		    for ($q = 0 ; $q < 4 ; ++$q)
		    {
			$s = substr($con[$q],$v,1);
			if ($s ne "O" && $char eq "O")
			{
			    $char = $s;
			}
			elsif($s eq "O" && $char ne "O")
			{
			    $char = $char;
			}
			else
			{
			    $char = "O";
			}
		    }
		    $res .= $char;
		}
	    
		print line1($con[0])," ",line1($con[1])," ",line1($con[2])," ",line1($con[3])," ",line1($res),"\n";
		print line2($con[0])," ",line2($con[1])," ",line2($con[2])," ",line2($con[3])," ",line2($res),"\n";
		print line3($con[0]),"+",line3($con[1]),"+",line3($con[2]),"+",line3($con[3]),"=",line3($res),"\n";
		print line4($con[0])," ",line4($con[1])," ",line4($con[2])," ",line4($con[3])," ",line4($res),"\n";
		print "\n";
	    }
	}
    }
}


		
		
