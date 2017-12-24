# the method 'Show' takes a single argument, a scalar or reference,
# and displays its contents.

package ShowDataStructure;

sub Indent
{
    my ($depth) = @_;
    for ($i = 0 ; $i < $depth ; $i++)
    {
	print " ";
    }
}

sub ShowSub
{
    my ($thing,$indent,$addresses) = @_;
    Indent($indent);

    # it's not a reference...just show it.
    if (!ref($thing))
    {
	print "VALUE: $thing\n";
	return;
    }

    # if we get here, it's some kind of reference.
    # this little codelet gets us the actual reference type
    # even if the thing got blessed.

    my ($dummy,$blessname,$reftype,$address) = 
	$thing =~ /^(([^=]+)=)?([^\(]+)\(([^\)]+)\)$/;

    if (length($reftype) == 0)
    {
	print "Unparseable thing: $thing\n";
	return;
    }

    # ok...if we get here, we have a reference that can itself
    # contain other things....recursion might be an issue.
    # judicious use of the $looped variable should keep us from 
    # infinitely recursing.

    my $looped = 0;
    if (exists $addresses->{$address})
    {
	$looped = 1;
    }
    $addresses->{$address} = 1;

    # make a description string
    my $description;
    $description = " \@ " . $address;
    if (length($blessname) != 0)
    {
	$description .= " (blessed as " . $blessname . ")";
    }

    # start doing stuff to the specific types...

    if ($reftype eq "SCALAR")
    {
	print "SCALAR: ",$$thing,$description,"\n";
	return;
    }

    if ($reftype eq "CODE" || $reftype eq "GLOB" || $reftype eq "LVALUE")
    {
	print "$reftype (unknown properties) $description\n";
	return;
    }

    if ($reftype eq "REF")
    {
	print "REF:$description\n";
	if (!$looped)
	{
	    ShowSub($$thing,$indent+2,$addresses);
	}
	return;
    }

    if ($reftype eq "ARRAY")
    {
	print "ARRAY size = ",scalar @$thing,":$description\n";
	my $i;
	return if $looped;
	for ($i = 0 ; $i < @$thing; $i++)
	{
	    Indent($indent+2);
	    print "Index $i:\n";
	    ShowSub($thing->[$i],$indent+4,$addresses);
	}
	return;
    }

    if ($reftype eq "HASH")
    {
	print "HASH size = ",scalar keys(%$thing),":$description\n";

	return if $looped;
	my $key;
	foreach $key (sort keys(%$thing))
	{
	    Indent($indent+2);
	    print "Key $key:\n";
	    ShowSub($thing->{$key},$indent+4,$addresses);
	}
	return;
    }

    print "UNKNOWN THING: $thing\n";

    return;
}

sub Show
{
    my ($thing) = @_;
    my %addresses;
    undef %addresses;

    ShowSub($thing,0,\%addresses);

}


1;
