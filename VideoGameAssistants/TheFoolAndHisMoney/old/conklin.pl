use Utility;

@words=(hailstorm,fisherman,confident,nightmare,revolting,cornfield,parchment,specialty);

my $perms = Utility::PermuteArray(\@words);

for $perm (@$perms)
{
    print 
	substr($perm->[0],5,1),
	substr($perm->[1],6,1),
	substr($perm->[2],3,1),
	substr($perm->[3],5,1),
	'y',
	substr($perm->[4],5,1),
	substr($perm->[5],1,1),
	substr($perm->[6],4,1),
	substr($perm->[7],6,1),
	"\n";
}

      
    
