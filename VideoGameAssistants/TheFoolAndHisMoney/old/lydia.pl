
$letters = "egloprstw";

# of the form 'tgngwd';
$garg = '\'^[' . $letters . ']{5}$\''; #';
$gfilt = '\'^.(.).\1..$\''; #';
@threeletters = split("\n",`grep -E $garg words | grep -E $gfilt `);

# of the form 'tgndwwd'
for $tl (@threeletters)
{
    $t = substr($t1,0,1);
    $g = substr($t1,1,1);
    $n = substr($t1,2,1);
    $w = substr($t1,4,1);
    $d = substr($t1,5,1);

    $garg = '\'^' . $t . $g . $n . $d . $w . $w . $d . '$\''; #';

    @fourletters = split("\n",`grep -E $garg words`);

    # seven letter of the form 'tgnndw'
    for $fl (@fourletters)
    {
	$garg = '\'^' . $t . $g . $n . $n . $d . $w . '$\''; #';
	@sevenletters = split("\n",`grep -E $garg words`);
	for $sl (@sevenletters)
	{
	    print $tl," ",$fl," ",$sl,"\n";
	}
    }
}


