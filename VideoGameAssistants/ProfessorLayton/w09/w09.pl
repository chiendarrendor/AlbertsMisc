
use lib "C:/msys/1.0/home/Chien/Common/Perl";
use Permute;

@perms = Permute::Permute("1122225");
%res;

for ($i = 0 ; $i < @perms ; ++$i)
{
    $n1 = 10 * substr($perms[$i],0,1) + substr($perms[$i],1,1);
    $n2 = 10 * substr($perms[$i],2,1) + substr($perms[$i],3,1);
    $res = 
	100 * substr($perms[$i],4,1) +
	10 * substr($perms[$i],5,1) + 
	substr($perms[$i],6,1);

    $res{$perms[$i]} = 1 if ($n1 * $n2 == $res);
}
	
foreach $k (keys %res)
{
    print $k,"\n";
}


