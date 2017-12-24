BEGIN { push @INC, "../../Common/Perl"; }
use Permute;

@perms = Permute::Permute("123456789");
print scalar @perms,"\n";
for $p (@perms) {
    $ss1 = substr($p,0,5);
    $ss2 = substr($p,5,4);

    next unless $ss1 - $ss2 == 33333;
    print "$p,$ss1,$ss2\n";
    exit(1);
}


