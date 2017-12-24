die("bad command line") unless @ARGV;
$orig = $ARGV[0];
$l = length($orig);
@results = split("\n",`grep -E '^\[$orig\]\{$l\}\$' wordsEn.txt`);

@ol = sort split("",$orig);

for $res (@results)
{
    @rl = sort split("",$res);
    for ($i = 0 ; $i < @rl ; ++$i)
    {
	last unless $ol[$i] eq $rl[$i];
    }
    next unless $i == @rl;
    print $res,"\n";
}

    
