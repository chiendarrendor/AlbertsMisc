
@set = ( earth , air , fire , water );
%combins = {};
$| = 1;

$done = 0;

while (!$done)
{
    $done = 1;
    for ($i = 0 ; $i < @set ; ++$i)
    {
	for ($j = $i ; $j < @set ; ++$j)
	{
	    next if exists $combins{$set[$i],$set[$j]};
	    
	    $done = 0;
	    print "Try $set[$i],$set[$j]:";
	    $inline = <stdin>;
	    $combins{$set[$i],$set[$j]} = $inline;

	    chomp $inline;
	    next if $inline eq '';
	    goto ADD;
	}
    }

ADD:
    @newitems = split(/,/,$inline);
    for ($i = 0 ; $i < @newitems ; ++$i)
    {
	unshift @set,$newitems[$i];
	
    }
}



