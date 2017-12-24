$version = '0.2';
$date = '16 Jun 2000';
$time = scalar(localtime);

require 'getopts.pl';
&Getopts('rf');

$pyname = $ARGV[0] or die "Usage: perl -w py.pl [ -fr ] <file>";
$pyfile = $pyname . '.py';
$infile = $pyname . '.output';
$rulefile = $pyname . '-rules.pl';
$outfile = $pyname . '.pl';

open(Y , "< $infile") or die "Can't open <$infile : $!";
open(P , "> $outfile") or die "Can't open >$outfile : $!";
if ($opt_r) {
  if (-e $rulefile && !$opt_f) {
    die "Rule file \`$rulefile\' exists.\nUse -f option to overwrite it.\n";
  }
  open(R , "> $rulefile") or die "Can't open >$outfile : $!";
}
while (<Y>) {
  chop;
  next unless (/\S/);
  if (/^rule (\d+)/) {
    $ruleno = $1;
    s/^rule \d+\s+//;
    $rules[$ruleno] = $_;
    ($rhs, $lhs) = /^(\S+)\s+\-\>\s+(.*)$/;
    @wrds = split(/\s+/, $lhs);
    $length[$ruleno] = scalar(@wrds);
    $rhs[$ruleno] = $rhs;
  } elsif (/^state (\d+)/) {
    $state = $1;
    next;
  } elsif (!defined($state)) {
    next;
  }
  next if /\-\>/;
  ($lhs, $rhs) = /\s*(\S+)\s+(.*)$/;
  if ($lhs eq "\$") {
    $lhs = 'End_of_Input'; 
    $rhs =~ /^go to state (\d+)/;
    $act{$state,$lhs} = "goto $1";
    next;
  }
  $lhs =~ s/^\'(\\?.)\'$/$1/;
  if ($rhs =~ /^shift, and go to state (\d+)$/) {
    $act{$state,$lhs} = "shift $1";
  } elsif ($rhs =~ /^reduce using rule (\d+)/) {
    $act{$state,$lhs} = "reduce $1";
  } elsif ($rhs =~ /^go to state (\d+)/) {
    $act{$state,$lhs} = "goto $1";
  } elsif ($rhs =~ /^accept$/) {
    $act{$state,$lhs} = "accept";
  } else {
    warn "Unrecognized RHS in state $state: $rhs\n$_\n";
  }
}
close Y;

print P <<EOF;
#
# parse language described in $infile
# Perl source code automatically generated at $time by
# py v.$version $date
# Source code copyright 1995 M-J. Dominus (mjd\@pobox.com)
# Patched 2000 kwe\@Death.Earth
#

require 'py-skel.pl';
require '$rulefile';

\$; = \"\\034\";
\%act = \(
EOF

foreach $key (keys %act) {
  $val = $act{$key};
  $key =~ s/([^\020-\176])/sprintf("\\x%x", unpack('c', $1))/ge;
  $key =~ s/([\$\"])/\\$1/g;
  print P "\"$key\",\t\'$val\',\n";
}

print P ");\n\@length = (";
foreach $l (@length) {
  print P ($l||0), ', ';
}

print P ");\n\n\@rhs = ('', ";

foreach $rhs (@rhs) {
  next unless (defined $rhs);
  $rhs =~ s/\'/\\\'/g;
  print P "\'$rhs\', ";
}
print P ");\n\n";

print P "\@rule = (\n'',\n";
for ($r=0; $r <= $#rules; $r++) {
  $rule = $rules[$r];
  next unless (defined $rule);
  $rule =~ s/\\/\\\\/g;
  $rule =~ s/\'/\\\'/g;
  print P "  \'$rule\',\n";
}
print P ");\n\n";

close P;

if ($opt_r) {
  print R <<EOF;
#
# Reduction rules for $outfile
# Perl source code automatically generated at $time by
# py v.$version $date
# Source code copyright 1995 M-J. Dominus (mjd\@pobox.com)
# patched 2000 kwe\@Death.Earth
#
EOF

  open(Y,"<$pyfile") or die "Can't open <$pyfile : $!";
  while (<Y>) {
    last if (/\{\s*\/\* py \*\//);
  }
  while (<Y>) {
    last if (/\}\s*\/\** py \*\//);
    print R "$_";
  }
  close(Y);

  for ($r=1; $r <= $#rules; $r++) {
    print R <<EOF;
# rule $r
# $rules[$r]
sub rule_$r {
EOF

    $find = $rules[$r];
    ($a,$b) = split /\-\>/, $find;
    $a =~ s/ //g;
    $a =~ s/$/:/;
    $b =~ s/^\ +//;
    $a =~ s/\+/\\\+/g;
    $a =~ s/\*/\\\*/g;
    $a =~ s/\?/\\\?/g;
    open(Y,"<$pyfile") or die "Can't open <$pyfile : $!";
print "SEARCH $a $b or | $b\n";
    while ($line = <Y>) {
      last if ($line =~ m/\Q$a\E\s+\Q$b\E|\|\s+\Q$b\E/);
    }
if (defined $line) { 
  print "FOUND $line\n";
} else {
  print "NOT FOUND\n";
}
    while (<Y>) {
      last if (/\/\* py \*\//);
      print R "$_";
    }
    if (defined $_) {
      s/\/\* py \*\///;
      print R "$_";
    }
    close(Y);
    print R "\n}\n";
  }
  print R "1;";
  close R;
}
