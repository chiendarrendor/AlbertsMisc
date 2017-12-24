#! /bin/perl

die("bad command line\n") unless @ARGV == 1;
my $filename = $ARGV[0];

die("can't open file\n") unless open FD,$filename;

my %charcount;
while(<FD>)
{
    $_ =~ s/\r?\n$//;
    my @car = split(//);

    for (my $i = 0 ; $i < @car ; ++$i)
    {
	++$charcount{$car[$i]};
    }
}

close FD;

for my $key (sort keys %charcount)
{
    print $charcount{$key}," ";
}
print "\n";






