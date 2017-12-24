package NewickNode;

sub new 
{
    my ($class,$name) = @_;
    my $this = {NAME=>$name,NEIGHBORS=>[]};
    bless $this,$class;
    return $this;
}

sub AddNeighbor
{
    my ($this,$neighbor,$distance) = @_;
    push @{$this->{NEIGHBORS}},[$neighbor,$distance];
}


1;


    
