BEGIN { push @INC,"../common"; }
use FASTA;

die("bad command line") unless @ARGV;
my $ff = new FASTAFILE($ARGV[0]);
my $fastas = $ff->GetFASTAS();

# step 1. remember for each unique 3-prefix of each FASTA, what its name is.
for $f (@$fastas)
{
    push @{$prefixes{substr($f->GetDNA(),0,3)}} , $f->GetName();
}

# step 2.  for each fasta, find its 3-suffix, and join it
# to all prefixes found above (ignore self)
for $f (@$fastas)
{
    my $suffix = substr($f->GetDNA(),-3,3);
    for $other (@{$prefixes{$suffix}})
    {
	next if $other eq $f->GetName();
	print $f->GetName()," ",$other,"\n";
    }
}

