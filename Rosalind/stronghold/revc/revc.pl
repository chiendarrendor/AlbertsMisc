#! /bin/perl

die("bad command line\n") unless @ARGV == 1;
my $filename = $ARGV[0];

die("can't open file\n") unless open FD,$filename;

while(<FD>)
{
    $_ =~ s/\r?\n$//;
    $_ =~ tr/ACTG/TGAC/;
    print (join "",reverse split(//)),"\n";
}

close FD;






