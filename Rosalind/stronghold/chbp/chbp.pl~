BEGIN { push @INC,"../common"; }

use TaxaTree;
use Character;

die("bad command line") unless @ARGV;
open(FD,$ARGV[0]) || die("can't open file");

$taxa = <FD>;
$taxa =~ s/\r?\n$//;

@taxa = split(" ",$taxa);
for $t (@taxa)
{
    $nodes{$t} = new TaxaTree($t);
}

sub PrintCharacters
{
    print "------------\n";
    for $c (@characters)
    {
	print $c->ToString(),"\n";
    }
}

while(<FD>)
{
    $_ =~ s/\r?\n$//;
    my $c0 = new Character();
    my $c1 = new Character();

    for ($i = 0 ; $i < length($_) ; ++$i)
    {
	$c = substr($_,$i,1);
	if ($c eq "0") { $c0->AddTaxa($nodes{$taxa[$i]}); }
	else { $c1->AddTaxa($nodes{$taxa[$i]}); }
    }

    push @characters,$c0;
    push @characters,$c1;
}

@characters = sort { scalar keys %{$a->{TAXA}} <=> scalar keys %{$b->{TAXA}} } @characters;


PrintCharacters();

while(@characters > 4)
{
    for ($i = 0 ; $i < @characters ; ++$i)
    {
	$tc = $characters[$i]->TaxaCount();
	last if  $tc == 2;
    }
    die("No doublets") if $i == @characters;

    $ach = splice @characters,$i,1;
    $ach->MakeTriple();

    PrintCharacters();
}

PrintCharacters();
exit(1);



# there should be one character left.  it should have three
# taxa.  Make one last tree node and join them.
$nn = new TaxaTree("");
($c1,$c2,$c3) = values %{$characters[0]->{TAXA}};
$nn->AddChild($c1);
$nn->AddChild($c2);
$nn->AddChild($c3);

print $nn->NewickString(),"\n";
    



    


close FD;


