BEGIN { push(@INC,"../Common/Perl"); }

use Nullable;

my $lineno = 1;
my $pbchar = new Nullable();
my $fd;

sub GetChar
{
    my $buf;
    my $result = new Nullable();

    if (!$pbchar->IsNull())
    {
	$result->Set($pbchar->Get());
	$pbchar->SetNull();
	return $result;
    }

    return $result if read($fd,$buf,1) == 0;

    if (ord($buf) eq 10)
    {
	$lineno++;
    }

    $result->Set($buf);

    return $result;
}

sub UnGetChar
{
    my ($char) = @_;
    $pbchar->Set($char);
}

sub RawGetToken
{
    my $bufref;
    my $result = new Nullable();
    my $isquote = undef;

    while(1)
    {
	$bufref = GetChar();

	last if ($bufref->IsNull());

	my $buf = $bufref->Get();

	if ($isquote)
	{
	    $result->Append($buf);
	    return $result if $buf eq '?';
	}

	if ($buf =~ /\s/)
	{
	    if (!$result->IsNull())
	    {
		return $result;
	    }
	    next;
	}

	if ($buf =~ /\w/)
	{
	    $result->Append($buf);
	    next;
	}
	# if we get here, $buf is a non whitespace,non-word character.
	if (!$result->IsNull())
	{
	    UnGetChar($buf);
	    return $result;
	}

	# if we get here, it is because the first character of note
	# is a non-whitespace,non-word character.

	# ?stuff? processing
	if ($buf eq '?')
	{
	    $result->Append($buf);
	    $isquote = 1;
	    next;
	}

	$result->Set($buf);
	return $result;
    }

    die("Unterminated ?-quoted string!\n") if $isquote;

    return $result;
}


sub FDLGetToken
{
    my $token = RawGetToken();

    return ( '',undef) if $token->IsNull();
    my $tstr = $token->Get();

    return ( 'IF','IF') if $tstr eq 'If';
    return ( 'INT','INT') if $tstr eq 'Int';
    return ( 'BYTE','BYTE') if $tstr eq 'Byte';
    return ( 'BYTES','BYTES') if $tstr eq 'Bytes';
    return ( 'SHORT','SHORT') if $tstr eq 'Short';
    return ( 'STRING','STRING') if $tstr eq 'String';
    return ( 'SKIPBYTES','SKIPBYTES') if $tstr eq 'SkipBytes';
    return ( 'DEFINE','DEFINE' ) if $tstr eq 'Define';
    return ( 'BITS','BITS' ) if $tstr eq 'Bits';
    return ( 'SUB','SUB' ) if $tstr eq 'Sub';
    return ( $tstr,$tstr ) if ($tstr =~ /^[;:(),{}]$/);
    return ( 'PERLEXP',substr($tstr,1,-1) ) if ($tstr =~ /^\?.*\?$/);
    return ( 'BITNUM',$tstr) if ($tstr =~ /^b[0-7]+$/);
    return ( 'NUM',$tstr) if ($tstr =~ /^\d+$/);
    return ( 'NAME',$tstr) if ($tstr =~ /^\w+$/);
    die("Unknown token ($tstr)\n");
}

sub SetupFDLFD
{
    my ($fname) = @_;
    open(FDLFILE,$fname) || die("Can't open $fname\n");
    $fd = \*FDLFILE;
}

sub GetLexerLine
{
    return $lineno;
}


1;
	
	
	

    
    
