
use ShowDataStructure;

sub GetInt
{
    my ($fh) = @_;
    my $buf;
    read $fh,$buf,4;
    return unpack("I",$buf);
}

sub GetShort
{
    my ($fh) = @_;
    my $buf;
    read $fh,$buf,2;
    return unpack("S",$buf);
}

sub GetString
{
    my ($fh,$size) = @_;
    my $buf;
    read $fh,$buf,$size;
    return unpack("Z$size",$buf);
}

sub Get8Bits
{
    my ($fh) = @_;
    my $buf;
    read $fh,$buf,1;
    my $res = unpack("b8",$buf);
    $res =~ tr/01/ny/;
    return $res;
}

sub GetBytes
{
    my ($fh,$size) = @_;
    my $buf;
    read $fh,$buf,$size;
    my @ary = unpack("C$size",$buf);
    return \@ary;
}

sub GetByte
{
    my ($fh) = @_;
    return GetBytes($fh,1)->[0];
}

sub Decode
{
    my ($string,$decoder) = @_;
    my $result;
    my $body = "\$result = $decoder(\$string)";
    eval "$body";
    die "Decode failed ($body): $@" if $@;

    return $result;
}

sub GetFDLStructure
{
    my ($fh,$fdldesc) = @_;
    my $result = {};

    my $i;

    my %defines;

    for ($i = 0 ; $i < @$fdldesc ; ++$i)
    {
	my $curdesc = $fdldesc->[$i];
	my $type = $curdesc->{TYPE};
	my $local;

	if (exists($curdesc->{BOOLEAN}))
	{
	    my $do;
	    my $estring = "\$do = (" . $curdesc->{BOOLEAN} . ")";
	    eval $estring;
	    die("Couldn't execute $estring\n") if ($@);

	    next if (!$do);
	}

	if ($type eq "Int")
	{
	    $local = GetInt($fh);
	    $local = Decode($local,$curdesc->{DECODE}) if exists($curdesc->{DECODE});
	    $result->{$curdesc->{NAME}} = $local;
	}
	elsif ($type eq "Byte")
	{
	    $local = GetByte($fh);
	    $local = Decode($local,$curdesc->{DECODE}) if exists($curdesc->{DECODE});
	    $result->{$curdesc->{NAME}} = $local;
	}
	elsif ($type eq "Bytes")
	{
	    $local = GetBytes($fh,$curdesc->{LENGTH});
	    $result->{$curdesc->{NAME}} = $local;
	}      
    
	elsif ($type eq "Short")
	{
	    $local = GetShort($fh);
	    $local = Decode($local,$curdesc->{DECODE}) if exists($curdesc->{DECODE});
	    $result->{$curdesc->{NAME}} = $local;
	}
	elsif ($type eq "String")
	{
	    $local = GetString($fh,$curdesc->{LENGTH});
	    $result->{$curdesc->{NAME}} = $local;
	}
	elsif ($type eq "SkipBytes")
	{
	    $local = GetBytes($fh,$curdesc->{LENGTH});
	}
	elsif ($type eq "Define")
	{
	    $defines{$curdesc->{NAME}} = $curdesc->{BODY};
	}
	elsif ($type eq 'Sub')
	{
	    my $body = undef;
	    $body = $curdesc->{BODY} if exists($curdesc->{BODY});
	    if (exists($curdesc->{BODYNAME}) && exists($defines{$curdesc->{BODYNAME}}))
	    {
		$body = $defines{$curdesc->{BODYNAME}} ;
	    }
	    die("Can't find Body for Sub ".$curdesc->{NAME}."\n") unless($body);

	    my $subres = GetFDLStructure($fh,$body);
	    $subres = Decode($subres,$curdesc->{DECODE}) if exists $curdesc->{DECODE};
	    $result->{$curdesc->{NAME}} = $subres;
	}
	elsif ($type eq 'Bits')
	{
	    $local = Get8Bits($fh);
	    my $j;
	    for ($j = 0 ; $j < @{$curdesc->{BITS}} ; $j++)
	    {
		my $bit = $curdesc->{BITS}->[$j];

		my $k;
		my $bitres = "";
		for ($k = 1 ; $k < length($bit->{NUM}) ; ++$k)
		{
		    $bitres .= substr($local,substr($bit->{NUM},$k,1),1);
		}
		
		$bitres = Decode($bitres,$curdesc->{DECODE}) if $curdesc->{DECODE};

		$result->{$bit->{NAME}} = $bitres;
	    }
	}
	else
	{
	    die("Unknown code $type");
	}
    }
    return $result;
}





1;
