#    py-skel.pl: perl yacc parser skeleton
#    Copyright 1995 Mark-Jason Dominus (mjd@pobox.com)
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
#

sub yyparse {
  local($lookahead);
  $state = 0;
  $nextplease = 1;
  @states = ();			# State stack
  @values = ();			# Value stack
  for (;;) {
    $lookahead = &yylex if $nextplease;
    print STDERR "\nLookahead token is $lookahead($yylval).\n" if $yydebug;
    print STDERR "State is $state.\n" if $yydebug;
    print STDERR "Top value is $values[$#values]\n" if $yydebug;
    local($act) = $act{$state,$lookahead} || $act{$state,'$default'};
    unless (defined($act)) {	# Wrong token
      print STDERR "No action found.\n" if $yydebug;
      until ($act{$state,'error'}) {
	$state = pop @states || return 1;
	print STDERR "Popping state stack looking for error transition.\n" if $yydebug;
      }
      print STDERR "Error transition found in state $state.\n" if $yydebug;
    }
    local($a, $d) = split(' ', $act);
    if ($a eq 'shift') {
      print STDERR "Shifting $lookahead($yylval).\n" if $yydebug;
      push(@values, $yylval);
      push(@states, $state);
      print STDERR "Val stack is (@values)\n" if $yydebug;
      print STDERR "State stack is (@states)\n" if $yydebug;
      $state = $d;
      print STDERR "New state is $state.\n" if $yydebug;
      $nextplease = 1;
    } elsif ($a eq 'reduce') {
      print STDERR "Reducing by rule $d ($rule[$d])\n" if $yydebug;
      print STDERR "Val stack is (@values)\n" if $yydebug;
      print STDERR "State stack is (@states)\n" if $yydebug;
      @args = splice(@values, -$length[$d]);
      $rule = "rule_$d";
      print STDERR "...Reducing...\n" if $yydebug;
      push (@values, &$rule(@args));
      print STDERR "Val stack is (@values)\n" if $yydebug;
      splice(@states, -($length[$d]-1)) if $length[$d] > 1;
      $state = $states[$#states];
      print STDERR "Returning to state $state.\n" if $yydebug;
      print STDERR "State stack is (@states)\n" if $yydebug;
      local($rhs) = $rhs[$d];
      print STDERR "rhs is \`$rhs\'\n" if $yydebug;
      $act = ($act{$state,$rhs} || 
	      (print STDERR "Ow! No action in new state!\n"));
      ($a, $d) = split(' ', $act);
      if ($a eq 'goto') {
	$state = $d;
	print STDERR "Jumping to state $d.\n" if $yydebug;
      } else {
	print STDERR "Action resulting from reduction to $rhs in state $state was $act, should have been a goto.\n";
      }
      $nextplease = 0;
    } elsif ($a eq 'goto') {
      print STDERR "EOF action is to go to state $d.\n" if $yydebug;
      $state = $d;
      $nextplease = 0;
    } elsif ($a eq 'accept') {
      print STDERR "Accepting.\n" if $yydebug;
      return 0;
    } else {
      die "Unrecognized action $act.\n";
    }
  }
}

1;
