
%trans = ( 'o' => 'y',
	   'u' => 'o',
	   'i' => 'u',
	   'y' => 'a',
	   't' => 'd',
	   'd' => 'j',
	   'a' => 'l',
	   'b' => 'u',
	   'c' => 'e',
	   'f' => 'i'
	   );

open(DFILE,"post.txt");

while(<DFILE>)
{
    chomp;

    @array = split(//);
    $inquote = 0;

    print "O:$_\nN:";

    for ($i = 0 ; $i < @array ; $i++)
    {

	$ch = $array[$i];

	if ($inquote == 1)
	{
	    if ($ch eq '"')
	    {
		print $ch;
		$inquote = 0;
		next;
	    }
	    
	    print $ch;

	}
	else
	{
	    if ($ch eq '"')
	    {
		print $ch;
		$inquote = 1;
		next;
	    }


	    if (exists $trans{$ch})
	    {
		$ch = $trans{$ch};
		$ch =~ y/a-z/A-Z/;
	    }
	    
	    print $ch;
	}
    }

    print "\n";
}

	
