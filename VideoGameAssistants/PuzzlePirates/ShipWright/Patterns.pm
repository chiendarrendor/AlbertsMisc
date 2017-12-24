package Pattern;

sub new
{
    my ($class,$patname) = @_;
    my $this = {};
    bless $this,$class;
    $this->{NAME} = $patname;
    $this->{WIDTH} = 0;
    $this->{HEIGHT} = 0;
    $this->{GRADE} = 0;
    return $this;
}

sub GetGrade
{
    my ($this) = @_;
    return $this->{GRADE};
}

sub SetGrade
{
    my ($this,$grade) = @_;
    return $this->{GRADE} = $grade;
}

sub GetName
{
    my ($this) = @_;
    return $this->{NAME};
}

sub GetWidth
{
    my ($this) = @_;
    return $this->{WIDTH};
}

sub GetHeight
{
    my ($this) = @_;
    return $this->{HEIGHT};
}

sub SetWidth
{
    my ($this,$width) = @_;
    $this->{WIDTH} = $width;
}

sub SetHeight
{
    my ($this,$height) = @_;
    $this->{HEIGHT} = $height;
}

sub SetCell
{
    my ($this,$x,$y,$value) = @_;
    $this->{CELLS}->[$x][$y] = $value;
}

sub GetCell
{
    my ($this,$x,$y) = @_;
    return $this->{CELLS}->[$x][$y];
}

package Patterns;

sub new
{
    my ($class,$fname) = @_;

    my $this = {};
    bless $this,$class;

    open(PATFILE,$fname) || die("Can't open pattern file\n");

    my $pattern = undef;

    while(<PATFILE>)
    {
	chomp;
	if (/(.+):/)
	{
	    if ($pattern)
	    {
		$this->{PATTERNS}->{$pattern->GetName()} = $pattern;
	    }
	    $pattern = new Pattern($1);
	    next;
	}

	die("Invalid file, no pattern name ($_)\n") unless $pattern;

	my $width = length;

	if ($pattern->GetWidth() != 0 && $pattern->GetWidth() != $width)
	{
	    die("Invalid file, inconsistent width in pattern "+$pattern->GetName()+"\n");
	}
	$pattern->SetWidth($width);
	$pattern->SetHeight($pattern->GetHeight() + 1);
	my $i;
	for ($i = 0 ; $i < $width ; ++$i)
	{
	    my $ch = substr($_,$i,1);
	    $pattern->SetGrade($pattern->GetGrade()+1) if $ch ne '.';
	    $pattern->SetCell($i,$pattern->GetHeight()-1,$ch);
	}
    }

    close PATFILE;

    return $this;
}

sub GetPattern
{
    my ($this,$pattern) = @_;

    if (exists $this->{PATTERNS}->{$pattern})
    {
	return $this->{PATTERNS}->{$pattern};
    }
    return undef;
}

1;

	
	
	    
