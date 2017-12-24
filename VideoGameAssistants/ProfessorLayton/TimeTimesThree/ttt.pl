use lib "C:/msys/1.0/home/Chien/Common/Perl";
use Permute;

sub ian($$)
{
    my ($str,$idx) = @_;
    my $char = substr($str,$idx,1);
    return $char + 0;
}

@result = Permute::Permute("1245689");

print "Begin: ",scalar @result,"\n";
for (my $i = 0 ; $i < @result ; ++$i)
{
    my $r = $result[$i];
    # 01 23       45 6
    # ab:cd x 3 = ef:g7

    next if ian($r,2) >= 6;
    next if ian($r,6) >= 6;

    my $op1 = (ian($r,0) * 10 + ian($r,1))*60 + ian($r,2)*10 + ian($r,3);
    my $op2 = (ian($r,4) * 10 + ian($r,5))*60 + ian($r,6)*10 + 7;
    
    next unless $op1*3 == $op2;

    print "$r\n";
}
print "End\n";
