
use fdl;
use FDLLexer;
use ShowDataStructure;

sub ErrorReport
{
    print "parse error on line ",GetLexerLine(),"\n";
    exit(1);
}

sub FDLParser
{
    my ($fname) = @_;
    SetupFDLFD($fname);

    my $parser = new fdl;

    my $result = $parser->YYParse(yylex=>\&FDLGetToken,yyerror=>\&ErrorReport);
#    ShowDataStructure::Show($result);

    return $result;

}

# FDLParser("d2s.fdl");

1;

    
