use DecodeData;

sub Hex
{
    my ($input) = @_;
    my $result;

    $result = sprintf("$x",$input);

    return result;
}

sub DecodeProgression
{
    my ($input) = @_;


    return $proglist[$input];
}

sub DecodeClass
{
    my ($input) = @_;


    return $classes[$input];
}

sub DecodeAct
{
    my ($input) = @_;

    return "Act I" if $input eq "nnn";
    return "Act II" if $input eq "nny";
    return "Act III" if $input eq "nyn";
    return "Act IV" if $input eq "nyy";
    return "Act V" if $input eq "ynn";
}

sub DecodeMercenary
{
    my ($input) = @_;

    my $classstring;
    my $name;

    if ($input->{UID} == 0)
    {
	$classstring = "";
	$name = "NONE";
    }
    else
    {
	my $cid = $input->{CLASS};
	$classstring = $mercclasses[$cid];

	if ($cid < 6)
	{
	    $name = $RogueScoutNames[$input->{NAME}];
	}
	elsif($cid < 15)
	{
	    $name = $DesertMercenaryNames[$input->{NAME}];
	}
	elsif($cid < 24)
	{
	    $name = $EasternSorcerorNames[$input->{NAME}];
	}
	else
	{
	    $name = $BarbarianNames[$input->{NAME}];
	}
    }
    
    $input->{CLASS} = $classstring;
    $input->{NAME} = $name;

    return $input;
}


	 

1;
