use FDLLexer;

SetupFDLFD("d2s.fdl");

my @ary;

while(1)
{
    @ary = FDLGetToken();
    print "(",join(",",@ary),") line: ",GetLexerLine(),"\n";
    last unless $ary[1];
}
