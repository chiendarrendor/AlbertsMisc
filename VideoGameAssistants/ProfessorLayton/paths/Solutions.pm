use Path;

package Solutions;

sub new
{
    my ($class,$start,$end,$verts) = @_;
    my $this = {};
    bless $this,$class;

    $this->{SOLS} = [];
    my @pendings;
    push @pendings,new Path($start,$verts);

    while(@pendings) {
	$op = pop @pendings;
	my @nar = $op->Extend();
	for (my $i = 0 ; $i < @nar ; ++$i) {
	    my $np = $nar[$i];
	    if ($np->Last() eq $end) {
		push @{$this->{SOLS}},$np;
	    } else {
		push @pendings,$np;
	    }
	}
    }
    return $this;
}







1;
