package ChainWords;

sub makeChain($) {
	my ($fname) = @_;
	my $root = new ChainWords("",0);
	open(my $fd,"<",$fname) || die("Can't find wordfile");
	while(<$fd>) {
		my @linewords = split /\s+/;
		for my $word (@linewords) {
			next unless $word =~ /^[a-zA-Z]+$/;
			$root->add(uc($word));
		}
	}
	return $root;
}



sub new($$$) { 
	my ($class,$prefix,$depth) = @_;
	my $this = {PREFIX=>$prefix,CHILDREN=>{},COUNT=>0,DEPTH=>$depth};
	return bless $this,$class;
}

# depth tells us what index to start at.
sub add($$) {
	my ($this,$word) = @_;
	++$this->{COUNT};
	my $prefix = substr($word,0,$this->{DEPTH});
	my $key = substr($word,$this->{DEPTH},1);
	my $suffix = substr($word,$this->{DEPTH});
#	print("'$word' '$prefix' '$key' '$suffix' ",$this->{DEPTH},"\n");
	die("Why?",$prefix," ",$this->{PREFIX}) unless $prefix eq $this->{PREFIX};
	if (length($suffix) == 1) {
		$this->{CHILDREN}->{$word} = 1;
		return;
	}

	$this->{CHILDREN}->{$key} = new ChainWords($prefix . $key,$this->{DEPTH}+1) unless exists $this->{CHILDREN}->{$key};
	$this->{CHILDREN}->{$key}->add($word);
}
	
sub show($$) {
	my ($this,$word) = @_;
	my $key = substr($word,$this->{DEPTH},1);
	print("Prefix: ",$this->{PREFIX}," Depth: ",$this->{DEPTH}," Count: ",$this->{COUNT},"\n");
	print(join(",",keys(%{$this->{CHILDREN}})),"\n");
	return if ($this->{DEPTH}+1 == length($word));
	if (!exists $this->{CHILDREN}->{$key}) {
		print("Can't go deeeper\n");
		return;
	}
	$this->{CHILDREN}->{$key}->show($word);
}

sub validate($$) {
	my ($this,$word) = @_;
	my $key = substr($word,$this->{DEPTH},1);
	return 1 if ($key eq "?");
	if ($this->{DEPTH}+1 == length($word)) {
		return exists $this->{CHILDREN}->{$word};
	}
	return 0 unless exists $this->{CHILDREN}->{$key};
	return $this->{CHILDREN}->{$key}->validate($word);
}






1;