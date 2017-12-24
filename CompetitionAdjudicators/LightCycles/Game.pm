
package Game;

my $timeout = 30;

my @board;
my $size;
my $uid = 0;
my $aloc;
my $bloc;
my $curturn;

# currently this just executes...it could do so much more
# in terms of:
# * protecting the board file from players
# * protecting the players from each other
# * ensuring that the players play within a particular time
sub ExecPlayer
{
    my ($pexec,$code,$board,$workdir) = @_;
    my $exline = "$pexec $code $board $workdir";
    my $result = `$exline`;
    chomp $result;
    return $result;
}

sub PrepMove
{
    my ($ploc,$pcode) = @_;
    SetCell($ploc->{X},$ploc->{Y},"$curturn$pcode");
}

sub IsWall
{
    my ($x,$y) = @_;
    my $cell = GetCell($x,$y);
    # a cell is a wall if it starts with a number
    # (otherwise it is either empty '.' or the 
    if ($cell =~ /^[0-9]/)
    {
	return 1;
    }
    else
    {
	return 0;
    }
}

sub ProcessMove
{
    my ($ploc,$pcode,$pmove) = @_;
    # bad if it isn't one character
    return 1 unless length($pmove) == 1;
    # bad if it isn't UDLR
    if ($pmove eq 'U')
    {
	return 1 if $ploc->{Y} == 0;
	return 1 if IsWall($ploc->{X},$ploc->{Y}-1);
	$ploc->{Y}--;
    }
    elsif($pmove eq 'D')
    {
	return 1 if $ploc->{Y} == $size-1;
	return 1 if IsWall($ploc->{X},$ploc->{Y}+1);
	$ploc->{Y}++;
    }
    elsif($pmove eq 'L')
    {
	return 1 if $ploc->{X} == 0;
	return 1 if IsWall($ploc->{X}-1,$ploc->{Y});
	$ploc->{X}--;
    }
    elsif($pmove eq 'R')
    {
	return 1 if $ploc->{X} == $size-1;
	return 1 if IsWall($ploc->{X}+1,$ploc->{Y});
	$ploc->{X}++;
    }
    else
    {
	return 1;
    }

    # if we didn't move off, and we didn't hit a wall, we're good.
    SetCell($ploc->{X},$ploc->{Y},$pcode);
    return 0;
}


sub BuildBoard
{
    ($size) = @_;
    for ($i = 0 ; $i < ($size * $size) ; ++$i)
    {
	$board[$i] = ".";
    }
    $curturn = 0;
}

sub GetCell
{
    my ($x,$y) = @_;
    return $board[$x * $size + $y];
}

sub SetCell
{
    my ($x,$y,$val) = @_;
    $board[$x * $size + $y] = $val;
}

sub WriteBoard
{
    my ($fname) = @_;
    open BF,">$fname";
    for (my $i = 0 ; $i < $size ; ++$i)
    {
	for (my $j = 0 ; $j < $size ; ++$j)
	{
	    print BF GetCell($j,$i), "  ";
	}
	print BF "\n";
    }
    close(BF);
}
	    




sub PlayGame
{
    my ($teama,$teamb,$workdir,$gamesize) = @_;
    BuildBoard($gamesize);

    my $movefile = "$workdir/moves.txt";
    open MF,">$movefile";
    print MF $teama->{NAME},",",$teamb->{NAME},"\n";

    $aloc = {X=>0,Y=>$gamesize/2};
    $bloc = {X=>$gamesize-1,Y=>$gamesize/2};

    $ac = $teama->{CODE};
    $bc = $teamb->{CODE};
    $aexec = $teama->{EXEC};
    $bexec = $teamb->{EXEC};

    SetCell($aloc->{X},$aloc->{Y},$ac);
    SetCell($bloc->{X},$bloc->{Y},$bc);

    $dirname = "$workdir/Game$uid";
    $uid++;
    system("rm -fr $dirname");
    mkdir($dirname);
    $awork = "$dirname/workA";
    mkdir($awork);
    $bwork = "$dirname/workB";
    mkdir($bwork);
    $bfile = "$dirname/board.txt";

    print "$teama->{NAME} vs $teamb->{NAME}\n";

    while(1)
    {
	WriteBoard("$bfile");

	$amove = ExecPlayer($aexec,$ac,$bfile,$awork);
	$bmove = ExecPlayer($bexec,$bc,$bfile,$bwork);

	$curturn++;
	PrepMove($aloc,$ac);
	PrepMove($bloc,$bc);

	$acrashed = ProcessMove($aloc,$ac,$amove);
	$bcrashed = ProcessMove($bloc,$bc,$bmove);

	# special case...ending up in the same space
	# is a mutual crash
	if ($aloc->{X} == $bloc->{X} &&
	    $aloc->{Y} == $bloc->{Y})
	{
	    $acrashed = 1;
	    $bcrashed = 1;
	}

	$aprint = ($amove ? $amove : "-") . ($acrashed ? "*" : "") ; 
	$bprint = ($bmove ? $bmove : "-") . ($bcrashed ? "*" : "") ;

	print MF "$aprint,$bprint\n";
	print "\t$aprint,$bprint\n";


	next if (!$acrashed && !$bcrashed);

	# if we get here, someone crashed.
	if (!$acrashed)
	{
	    $teama->{WINS}++;
	    $teamb->{LOSSES}++;
	    print "\t$teamb->{NAME} crashes! $teama->{NAME} wins!\n";
	}
	elsif (!$bcrashed)
	{
	    $teamb->{WINS}++;
	    $teama->{LOSSES}++;
	    print "\t$teama->{NAME} crashes! $teamb->{NAME} wins!\n";
	}
	else
	{
	    # if we get here, they _both_ crashed
	    $teama->{TIES}++;
	    $teamb->{TIES}++;
	    print "\t$teamb->{NAME} ties $teama->{NAME}!\n";

	}
	last;
    }
    close MF;
    return $movefile;
} 


1; 

