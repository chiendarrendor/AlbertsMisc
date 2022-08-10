#! /c/Perl64/bin/perl.exe
use strict; 

my $HIP = "High Priestess";
my $MAG = "Magician";
my $STR = "Star";
my $HER = "Hermit";
my $SGH = "Strength";
my $DEV = "Devil";
my $HIE = "Hierophant";
my $EMP = "Empress";
my $CHR = "Chariot";
my $JST = "Justice";
my $DTH = "Death";
my $LOV = "Lovers";

my @switches = ( 
	[ $HIP,$STR,$HIE ],
	[ $MAG,$HER,$SGH ],
	[ $STR,$HER,$DTH ],
	[ $HER,$EMP,$JST ],
	[ $SGH,$DEV,$HIE ],
	[ $DEV,$HIP,$EMP ],
	[ $HIE,$CHR,$LOV ],
	[ $EMP,$HER,$LOV ],
	[ $CHR,$MAG,$STR ],
	[ $JST,$MAG,$LOV ],
	[ $DTH,$JST,$STR ],
	[ $LOV,$DEV,$JST ]
	);



my @sets;

sub makerecurse($$$$) {
	my ($index,$depth,$usedar,$cardhash) = @_;
	
	push @sets,{ BUTTONS=>$usedar, CARDS=>$cardhash };
	return unless $depth > 0;
	
	for (my $i = $index ; $i < @switches ; ++$i) {
		my $newbuttons = [];
		for my $button (@$usedar) { push @$newbuttons,$button; }
		my $newcards = {};
		for my $key (keys %$cardhash) { $newcards->{$key} = $cardhash->{$key}; }
		
		my $curswitch = $switches[$i];
		push @$newbuttons, $curswitch->[0];
		for my $item (@$curswitch) {
			if (exists $newcards->{$item}) {
				delete $newcards->{$item};
			} else {
				$newcards->{$item} = 1;
			}
		}
		makerecurse($i+1,$depth-1,$newbuttons,$newcards);
	}
}

sub matches($$){
	my ($ent,$tstr) = @_;
	return 0 if (scalar keys %{$ent->{CARDS}} > scalar @$tstr);
	for my $item (@$tstr) {
		return 0 unless exists $ent->{CARDS}->{$item};
	}
	return 1;
}
	


makerecurse(0,7,[],{});

print "# of entries: ",scalar @sets,"\n";
my %counts;
for my $ent (@sets) {
	++$counts{scalar keys %{$ent->{CARDS}}};
}
for my $count (sort keys %counts) {
	print $count,": ",$counts{$count},"\n";
}
for my $ent (@sets) {
	next unless matches($ent,\@ARGV);
	print join(",",keys %{$ent->{CARDS}}),": ",join(",",@{$ent->{BUTTONS}}),"\n";
}



		