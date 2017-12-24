BEGIN {push @INC,"../common"; }

sub IsPurine
{
    my ($n) = @_;
    return index("AG",$n) != -1;
}

sub IsPyrimidine
{
    my ($n) = @_;
    return index("TC",$n) != -1;
}

sub IsTransition
{
    my ($a,$b) = @_;

    if($a eq $b)
    {
	return 0;
    }

    if (IsPurine($a) && IsPurine($b))
    {
	return 1 ;
    }

    if (IsPyrimidine($a) && IsPyrimidine($b))
    {
	return 1;
    }

    return 0;
}

sub IsTransversion
{
    my ($a,$b) = @_;
    return 0 if $a eq $b;
    return !IsTransition($a,$b);
}


use FASTA;

die("bad command line\n") unless @ARGV == 1;
my $fname = $ARGV[0];

my $file = new FASTAFILE($fname);
my $far = $file->GetFASTAS();

die("fasta count error") unless @$far == 2;

my $d1 = $far->[0]->GetDNA();
my $d2 = $far->[1]->GetDNA();

die("length mismatch") unless length($d1) == length($d2);

my $transitioncount = 0;
my $transversioncount = 0;

my $t = "";
for (my $i = 0 ; $i < length($d1) ; ++$i)
{
    my $c1 = substr($d1,$i,1);
    my $c2 = substr($d2,$i,1);

    if (IsTransition($c1,$c2))
    {
	++$transitioncount;
	$t .= "t";
    }
    elsif (IsTransversion($c1,$c2))
    {
	++$transversioncount;
	$t .= "v";
    }
    else
    {
	$t .= ".";
    }
}

my $r = $transitioncount  / $transversioncount;

printf("%.3f\n",$r);
