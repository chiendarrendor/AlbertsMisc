use Patterns;
use Board;
use Printers;
use BoardBFS;

select(STDOUT); $| = 1;


my $pats = new Patterns("Patterns.txt");

my $board = new Board($ARGV[0],$pats);

BoardBFS::BoardBFS($board);



#print "Grade: ",$board->{GRADE},"\n";
#for ($i = 0 ; $i < @{$board->{MATCHES}} ; ++ $i)
#{
#    ShowMatch($board,$board->{MATCHES}[$i]);
#}

#my @successors = $board->Successors();
#for ($i = 0 ; $i < @successors ; $i++)
#{
#    Show2Board($board,$successors[$i]);
#}
