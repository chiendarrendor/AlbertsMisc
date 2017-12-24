use Astar;

package SlidingState;

sub new
{
    my ($class,$slidinginfo) = @_;
    my $this = {};
    bless $this,$class;
    $this->{INFO} = $slidinginfo;
    $this->{DEPTH} = 0;
    $this->{POS} = $slidinginfo->GetStartPosition();
    $this->{DATA} = $slidinginfo->ValidatePosition($this->{POS});
    return $this;
}

sub cloneAndMove
{
    my ($this,$name,$dir) = @_;
    my $result = {};
    bless $result,ref $this;
    $result->{INFO} = $this->{INFO};
    $result->{DEPTH} = $this->{DEPTH} + 1;
    $result->{PARENT} = $this->CanonicalKey();
    $result->{MOVE} = $name . $dir;
    $result->{POS} = {};

    for my $pkey (keys %{$this->{POS}}) {
	if ($pkey ne $name) {
	    $result->{POS}->{$pkey} = [ $this->{POS}->{$pkey}->[0],$this->{POS}->{$pkey}->[1] ];
	} else {
	    if ($dir eq 'U') {
		$result->{POS}->{$pkey} = [ $this->{POS}->{$pkey}->[0],$this->{POS}->{$pkey}->[1] - 1 ];
	    } elsif ($dir eq 'D') {
		$result->{POS}->{$pkey} = [ $this->{POS}->{$pkey}->[0],$this->{POS}->{$pkey}->[1] + 1 ];
	    } elsif ($dir eq 'L') {
		$result->{POS}->{$pkey} = [ $this->{POS}->{$pkey}->[0]-1,$this->{POS}->{$pkey}->[1] ];
	    } elsif ($dir eq 'R') {
		$result->{POS}->{$pkey} = [ $this->{POS}->{$pkey}->[0]+1,$this->{POS}->{$pkey}->[1] ];
	    }
	}
    }
    $result->{DATA} = $result->{INFO}->ValidatePosition($result->{POS});
    return $result;
}

sub Successors
{
    my ($this) = @_;
    my @result;

    for my $tname (keys %{$this->{POS}}) {
	for my $dir ('U','D','L','R') {
	    my $newboard = $this->cloneAndMove($tname,$dir);
	    next unless defined $newboard->{DATA};
	    push @result,$newboard;
	}
    }
    return @result;
}

sub MakeString
{
    my ($this,$type) = @_;
    my $si = $this->{INFO};
    my $result = "";
    for (my $y = 0 ; $y < $si->{HEIGHT} ; ++$y ) {
	for (my $x = 0 ; $x < $si->{WIDTH} ; ++$x ) {
	    if (ref $this->{DATA}->{$x,$y}) {
		$result .= $this->{DATA}->{$x,$y}->{$type};
	    } else {
		$result .= $this->{DATA}->{$x,$y};
	    }
	}
	$result .= "\n";
    }
    return $result;
}

sub CanonicalKey
{
    my ($this) = @_;
    return $this->MakeString("KEYID");
}

sub DisplayString
{
    my ($this) = @_;
    return $this->MakeString("NAME");
}

sub Grade
{
    my ($this) = @_;
    my $result = 0;
    for my $tkey (keys %{$this->{POS}}) {
	my $tx = $this->{POS}->{$tkey}->[0];
	my $ty = $this->{POS}->{$tkey}->[1];
	$result -= $this->{INFO}->{TILES}->{$tkey}->{GRADES}->{$tx,$ty};
    }
    return $result;
}

sub Move
{
    my ($this) = @_;
    return $this->{MOVE};
}

sub Parent
{
    my ($this) = @_;
    return $this->{PARENT};
}

sub WinGrade
{
    return 0;
}

sub Depth
{
    my ($this) = @_;
    return $this->{DEPTH};
}


package SlidingAStar;

sub AStar
{
    my($slidinginfo,$doprint) = @_;

    my $initial = new SlidingState($slidinginfo);

    return Astar::Astar($initial,$doprint);
}


    
1;
