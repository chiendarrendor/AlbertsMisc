$s = "nuwettxththecenhntosaotlsoleuettsistnptyartrerreoo";
#     0123456789
#     x  x  x




for ($i = 0 ; $i < length($s) ; ++$i)
{
    $c = substr($s,$i,1);
    next unless $i%3 == 0;
    



    print $c;
}
print "\n";


for ($i = 0 ; $i < length($s) ; ++$i)
{
    $c = substr($s,$i,1);
    next unless $i%3 == 1;
    



    print $c;
}

print "\n";

for ($i = 0 ; $i < length($s) ; ++$i)
{
    $c = substr($s,$i,1);
    next unless $i%3 == 2;
    



    print $c;
}
print "\n";


    
