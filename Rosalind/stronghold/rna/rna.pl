#! /bin/perl

die("bad command line\n") unless @ARGV == 1;
my $filename = $ARGV[0];

die("can't open file\n") unless open FD,$filename;

while(<FD>)
{
    $_ =~ s/T/U/g;
    print;
}

close FD;







