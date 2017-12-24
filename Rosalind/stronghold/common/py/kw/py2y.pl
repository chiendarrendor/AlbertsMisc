$in = $ARGV[0] or die "Usage: py2y <file>";
$name = $in;
$name =~ s/\.py$//;
open (IN,"<$in") or die "Can't open $in: $!";
$out = $name . '.y';
open (OUT,">$out") or die "Can't open $out: $!";
$flag = 0;
while ($line = <IN>) {
  if ($line =~ m/^\s*{\s*$/) {
    $flag = 1;
  } elsif ($line =~ m/^\s*\{\s\/\* py \*\//) {
    $flag = 1;
  } elsif ($line =~ m/\}\s*\/\* py \*\//) {
    $flag = 0;
    next;
  }
  if ($flag == 0) {
    print OUT "$line";
  }
}
