#! /c/Perl64/bin/perl.exe
use strict;

my %suffixes;
sub gocsuffix($) {
	my ($suffix) = @_;
	return $suffixes{$suffix} if (exists $suffixes{$suffix});
	my $newent = {SUFFIX=>$suffix,FIVEWORDS=>[],SIXWORDS=>[],SEVENWORDS=>[]};
	$suffixes{$suffix} = $newent;
	return $newent;
}
sub addpair($$$) {
	my ($prefix,$suffix,$type) = @_;
	my $ent = gocsuffix($suffix);
	push @{$ent->{$type}},$prefix;
}
	
sub matches($$) {
	my ($orig,$probe) = @_;
	my %oar;
	for my $ochar (split(//,$orig)) {
		++$oar{$ochar};
	}
	for my $pchar (split(//,$probe)) {
		return 0 unless exists $oar{$pchar};
		return 0 unless $oar{$pchar} > 0;
		--$oar{$pchar};
	}
	return 1;
}


# ----------------------------------- main
if (@ARGV != 2) {
	print "Bad Command Line <prefix/suffix> <letters>\n";
	exit(1);
}

my $type = $ARGV[0];
my $rawletters = uc($ARGV[1]);
print "search on: ",$rawletters,"\n";


open(my $fd,"<","collinswords2019.txt");

my $wcount = 0;
my $count5 = 0;
my $count6 = 0;
my $count7 = 0;

while(<$fd>) {
	chomp;
	next unless length($_) >= 5 && length($_) <= 7;
	++$wcount;
	if (length($_) == 5) {
		if ($type eq "suffix") {
			addpair(substr($_,0,1),substr($_,1,4),"FIVEWORDS");
		} else {
			addpair(substr($_,4,1),substr($_,0,4),"FIVEWORDS");
		}
		++$count5;
	} elsif (length($_) == 6) {
		if ($type eq "suffix") {
			addpair(substr($_,0,2),substr($_,2,4),"SIXWORDS");
		} else {
			addpair(substr($_,4,2),substr($_,0,4),"SIXWORDS");
		}
		++$count6;
	} else {
		if ($type eq "suffix") {
			addpair(substr($_,0,3),substr($_,3,4),"SEVENWORDS");
		} else {
			addpair(substr($_,4,3),substr($_,0,4),"SEVENWORDS");
		}
		++$count7;
	}
}

print "Words loaded: $wcount total, $count5 5-letters, $count6 6-letters, $count7 7-letters\n";
print "Unique ${type}es: ",(scalar keys %suffixes),"\n";

my %fullsuffixes;
for my $key (keys %suffixes) {
	my $ent = $suffixes{$key};
	next unless @{$ent->{FIVEWORDS}} > 0;
	next unless @{$ent->{SIXWORDS}} > 0;
	next unless @{$ent->{SEVENWORDS}} > 0;
	$fullsuffixes{$key} = $ent;
}
print "Filled ${type}es: ",(scalar keys %fullsuffixes),"\n";

for my $key (keys %fullsuffixes) {
	next unless matches($rawletters,$key);
	my $ent = $fullsuffixes{$key};

	for (my $i = 0 ; $i < @{$ent->{FIVEWORDS}} ; ++$i) {
		my $onein = $key . $ent->{FIVEWORDS}->[$i];
		next unless matches($rawletters,$onein);
	
		for (my $j = 0 ; $j < @{$ent->{SIXWORDS}} ; ++$j) {
			my $twoin = $onein . $ent->{SIXWORDS}->[$j];
			next unless matches($rawletters,$twoin);
		
			for (my $k = 0 ; $k < @{$ent->{SEVENWORDS}} ; ++$k) {
				my $threein = $twoin .  $ent->{SEVENWORDS}->[$k];
				next unless matches($rawletters,$threein);
				
				if ($type eq "suffix") {
					print $ent->{FIVEWORDS}->[$i],$key," ",
						$ent->{SIXWORDS}->[$j],$key," ",
						$ent->{SEVENWORDS}->[$k],$key,"\n";
				} else {
					print $key,$ent->{FIVEWORDS}->[$i]," ",
						$key,$ent->{SIXWORDS}->[$j]," ",
						$key,$ent->{SEVENWORDS}->[$k],"\n";
				}
			}
		}
	}
}




