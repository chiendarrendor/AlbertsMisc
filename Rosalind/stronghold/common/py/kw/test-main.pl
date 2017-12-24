#
# Main program
#

require 'test.pl';

my @words = ( );

sub getWord {

  my $handle = shift;
  while (not @words) {
    my $line = <>;
    if (not defined $line) {
      return undef;
    }
    chomp $line;
    $line =~ s/#.*$//;
    @words = split /\s+/, $line;
  }
  $word = shift @words;
  return $word;
}

sub yylex {

  my $handle = shift;
  my $word = &getWord($handle);
  return End_of_Input unless defined $word;
  $yylval = $word;
  if ($word =~ m/^\d+$/) {
    return NUM;
  }
  if ($word eq '+' or $word eq '-' or $word eq '(' or $word eq ')') {
    return $word;
  }
  return WORD;
}

  my @values = yyparse(STDIN);
  if ($yyerror == 0) {
    print "@values\n";
  } else {
    $yyerror = 0;
    print "What?\n";
  }
1;
