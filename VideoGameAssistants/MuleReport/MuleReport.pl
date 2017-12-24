BEGIN { push(@INC,"../Common/Perl"); }


use ShowDataStructure;
use Readers;
use Decoders;
use FDLParser;

sub ProcessFile
{
    my ($filename) = @_;

    open(DSAVE,$filename) || die("Can't open file $filename");

    my $fdldesc = FDLParser("d2s.fdl");

    my $header=GetFDLStructure(\*DSAVE,$fdldesc);

    if ($header->{HEADER} != 0xaa55aa55 || $header->{VERSION} < 92)
    {
	return;
    }

    ShowDataStructure::Show($header);


    printf("%-20s Level %2d %s\n",$header->{NAME},$header->{LEVEL},$header->{CLASS});
    print "\tProgression: ",$header->{PROGRESSION},"\n";
    print "\tLast Played: ",$header->{TIMESTAMP},"\n";

    if ($header->{MERCENARY}->{UID} == 0)
    {
	print "\tNo Mercenary\n";
    }
    else
    {
	print "\tMerc: ",$header->{MERCENARY}->{NAME}, " is a ",$header->{MERCENARY}->{CLASS}," with ",
	      $header->{MERCENARY}->{XP}," XP.\n";
    }

    print "\n";
}



# main

my $dir="C:\\Program Files\\Diablo II\\save";

if (@ARGV > 0)
{
    $dir = $ARGV[0];
}

ProcessFile($dir . "\\" . "Hunter.d2s");
#ProcessFile($dir . "\\" . "Sheena.d2s");
exit(0);

opendir(SAVEDIR,$dir) || die("Can't open dir $dir");

while($entry = readdir(SAVEDIR))
{
    next unless $entry =~ /\.d2s$/;
    ProcessFile($dir . "\\" . $entry);
}
