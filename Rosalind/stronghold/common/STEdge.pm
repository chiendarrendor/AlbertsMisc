package STEdge;

use SubString;


sub new
{
    my ($class,$str,$child) = @_;
    my $this = {};
    bless $this,$class;
    $this->{STRING} = $str;
    $this->{FIRSTCHAR} = $str->GetCharAt(0);
    $this->{CHILD} = $child if $child;
    return $this;
}

# returns 0 if there is no initial overlap between 
# the given string and this edge's string
# otherwise, 
# a) if we are a terminal thus:
#    AB$
#    and ABC$ arrives
#    result should be:
#    AB
#      $
#      C$
#    if we are a terminal thus:
#    AB$
#    and A$ arrives
#    result should be
#    A
#       B$
#       $

# b) if we are non-terminal
#    AB <child node>
#    b1)
#    if ABC$ arrives, C$ should be handled by <child node>
#    if AC$ arrives:
#    A
#     <new child node>
#        B <child node>
#        C$


sub ProcessNewString
{
    my ($this,$string) = @_;
    my $idx = 0;

    my $slen = $string->Length()-1;
    my $llen = $this->{STRING}->Length() - (exists $this->{CHILD} ? 0 : 1);
    my $maxlen = $slen < $llen ? $slen : $llen;


    while($idx < $maxlen)
    {
	last unless $string->GetCharAt($idx) eq
	    $this->{STRING}->GetCharAt($idx);
	++$idx;
    }
    # invariant: $idx is now the count of 
    # letters that overlap betwee $this->{STRING} and $string
    # (not including a '$'
    return 0 if $idx == 0;

    # ok...so now there's some overlap
    # easy case.  if we're a terminal, the final result
    # will be that this edge now contains the overlap between the two
    # and point to a new node that contains the two 
    # terminal substrings.
    if (!exists $this->{CHILD})
    {
	my $common = $string->SubSubString(0,$idx);
	my $sub1 = $string->SubStringToEnd($idx);
	my $sub2 = $this->{STRING}->SubStringToEnd($idx);

	$this->{STRING} = $common;
	$this->{CHILD} = new STNode();
	$this->{CHILD}->AddEdge($sub1);
	$this->{CHILD}->AddEdge($sub2);
	return 1;
    }

    # ok, if we get here, we're a non-terminal.
    # another easy case.  if the length of overlap is 
    # our entire length, then let our child handle the entire thing.
    if ($llen eq $idx)
    {
	$this->{CHILD}->ProcessNewString($string->SubStringToEnd($idx));
	return 1;
    }

    # ok...if we get here, we're not a terminal, and
    # the overlap is only part of us.
    # so, originally:
    # <my string> -> child node
    # + new string
    #
    # new:
    # <shared prefix> -> new node
    #    new node:
    #         <unique suffix of my string> -> child node
    #         <unique suffix of new string
    #
    my $prefix = $this->{STRING}->SubSubString(0,$idx);
    my $mysuffix = $this->{STRING}->SubStringToEnd($idx);
    my $newsuffix = $string->SubStringToEnd($idx);
    $nn = new STNode();
    $nn->AddEdge($mysuffix,$this->{CHILD});
    $nn->AddEdge($newsuffix);
    $this->{CHILD} = $nn;
    $this->{STRING} = $prefix;

    return 1;
}

sub Print
{
    my ($this,$indent) = @_;
    print $indent,$this->{STRING}->ToString();
    print " -> ",$this->{FIRSTCHAR};

    print "\n";
    $this->{CHILD}->Print($indent . "\t") if exists $this->{CHILD};
}

sub PrintAllEdges
{
    my ($this) = @_;
    print $this->{STRING}->ToString(),"\n";
    $this->{CHILD}->PrintAllEdges() if exists $this->{CHILD};
}

sub FindCommonSubstrings
{
    my ($this,$prefix,$resref) = @_;
    return unless exists $this->{CHILD};
    my $string;
    if ($prefix)
    {
	$string = new SubString($this->{STRING}->{STRING},
				$this->{STRING}->{FIRST} - $prefix->Length(),
				$prefix->Length() + $this->{STRING}->Length);
    }
    else
    {
	$string = $this->{STRING};
    }

    my $count = $this->{CHILD}->GetLeafCount();
    push @$resref,[$string,$count];
    $this->{CHILD}->FindCommonSubstrings($string,$resref);
}

sub GetLeafCount
{
    my ($this) = @_;
    return 1 unless exists $this->{CHILD};
    return $this->{CHILD}->GetLeafCount();
}

sub CountByLength
{
    my ($this) = @_;
    my $mylen = $this->{STRING}->Length();

    return $mylen - 1 unless exists $this->{CHILD};
    return $mylen + $this->{CHILD}->CountByLength();
}


1;
