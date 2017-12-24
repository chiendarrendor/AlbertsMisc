package SuffixTree;
use StringWrapper;
use SubString;

sub new
{
    my ($class,$stringwrapper) = @_;
    my $this = {};
    bless $this,$class;

    # initial state of tree
    $this->{ROOT} = new STNode();
    $this->{ROOT}->AddEdge(new SubString($stringwrapper,$stringwrapper->Length()-1,1));

    print "len:",$stringwrapper->Length(),"\n";

    for (my $i = 0 ; $i < $stringwrapper->Length() - 1 ; ++$i)
    {
	print $i,"\n" if ($i%1000 == 0) ;
	my $ss = new SubString($stringwrapper,$i,$stringwrapper->Length()-$i);
	$this->{ROOT}->ProcessNewString($ss);
    }
    return $this;
}

sub CountByLength
{
    my ($this) = @_;
    return $this->{ROOT}->CountByLength();
}

sub Print
{
    my ($this) = @_;
    $this->{ROOT}->Print("");
}

sub PrintAllEdges
{
    my ($this) = @_;
    $this->{ROOT}->PrintAllEdges();
}

sub FindCommonSubstrings
{
    my ($this) = @_;
    my $result = [];
    $this->{ROOT}->FindCommonSubstrings(undef,$result);
    return $result;
}

package STNode;

use STEdge;

sub new
{
    my ($class) = @_;
    my $this = {};
    bless $this,$class;
    $this->{EDGES} = {};
    return $this;
}

# one of two things will happen
# a) one of the existing edges will know how to
#    handle this string, in which case we are done
# b) _none_ of the existing edges know how to handle
#    this string, in which case we make a new edge 
#    at this level.

sub ProcessNewString
{
    my ($this,$str) = @_;
    my $found = 0;
    my $fnc = $str->GetCharAt(0);

    for my $edge (@{$this->{EDGES}->{$fnc}})
    {
	my $st = $edge->ProcessNewString($str);
	if ($st == 1)
	{
	    $found = 1;
	    last;
	}
    }
    if ($found == 0)
    {
	$this->AddEdge($str);
    }
}  

sub FindCommonSubstrings
{
    my ($this,$prefix,$resref) = @_;
    for my $group (keys %{$this->{EDGES}})
    {
	for my $edge (@{$this->{EDGES}->{$group}})
	{
	    $edge->FindCommonSubstrings($prefix,$resref);
	}
    }
}

sub CountByLength
{
    my ($this,$length) = @_;
    my $result;
    for my $group (keys %{$this->{EDGES}})
    {
	for my $edge (@{$this->{EDGES}->{$group}})
	{
	    $result += $edge->CountByLength();
	}
    }
    return $result;
}



sub GetLeafCount
{
    my ($this) = @_;
    my $result = 0;
    for my $group (keys %{$this->{EDGES}})
    {
	for my $edge (@{$this->{EDGES}->{$group}})
	{
	    $result += $edge->GetLeafCount();
	}
    }
    return $result;
}

sub Print
{
    my ($this,$indent) = @_;
    for my $group (keys %{$this->{EDGES}})
    {
	print $indent,"($group)\n";
	for my $edge (@{$this->{EDGES}->{$group}})
	{
	    $edge->Print($indent);
	}
    }
}

sub PrintAllEdges
{
    my ($this) = @_;
    for my $group (keys %{$this->{EDGES}})
    {
	for my $edge (@{$this->{EDGES}->{$group}})
	{
	    $edge->PrintAllEdges();
	}
    }
}

sub AddEdge
{
    my ($this,$str,$child) = @_;
    my $fnc = $str->GetCharAt(0);
    my $ne = new STEdge($str,$child);
    push @{$this->{EDGES}->{$fnc}},$ne;
}



1;


