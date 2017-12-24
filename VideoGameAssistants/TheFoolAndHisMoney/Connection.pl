use ConnectionState;
use ConnectionGuesser;

my @first =
(
 " . . . t2 l b u",
 ". . n y e(a)4 k w",
 " k p s3 m f i",
 ". a e2 l u(oo) m"
);

my $firstg = new ConnectionGuesser(
    [1,4,3,4,3,1,4,3,6],
    ["a","fool","may","","","","","",""]);

my @second =
(
 " o w(v) z(s)2 w e(oo) i3",
 ". r e2 d f l2 w",
 " . m a3 a2 l e3 r2",
 ". . b(pp) n m h w"
);

my $secondg = new ConnectionGuesser(
    [1,4,4,6,5,1,4,3,8],
    ["a","fool","","","","a","","",""]
    );



my @third = 
(
 "  d  t c  h3  l    t",
 "e  d  v e6  t2  e    f",
 " t2 i4 a  w3  n3 o(oo)",
 ".  .  s d   o2"
);

# Eddtvi... tis Itia don'o onon we, cew Eweh ehe't thle tf.
#           the Wise don't want it, the Fool can't      it
my $thirdg = new ConnectionGuesser(
    [6,3,4,4,4,2,3,4,4,4,2],
    ["advice","the","wise","wont","need","it","the","fool","wont","heed","it"]
    );



my @fourth =
(
 " i x(ng)     o f2 a  o3     u     e2 w l",
 ". .     .     . i  l2 h2     i     h  y(lp)",
 " . . .         . t  d  s3     s     a",
 ". . .     v(em) w o  f  c(ra)  k(is) b(an)"
);

my $fourthg = new ConnectionGuesser(
    [ 2, 1, 4, 5, 3 , 6, 2, 4, 4, 3, 1, 4, 3 ],
    ["if","a","fool","holds","his","tongue",
     "he","will","pass","for","a","wise","man"]);

my @fifth = 
(
 " f3 o3 t n v r w(o) l",
 ". a2 w l a2 r i s(as)",
 " . . . t2 e6 s2 m2 t",
 ". . . . h3 w a n t"
);

my $fifthg = new ConnectionGuesser(
    [ 6, 3, 7,2,1,4,3,3,6,2,1,4],
    ["wealth","","","of","a","wise","man","","","of","a","Fool"]
    );

my @sixth = 
(
 " a r g(ol) i k o2 v",
 ". e2 p2 w a3 n r2 e",
 " . t2 s3 e2 m2 s b2",
 ". m h e c(f) a t u"
);

my $sixthg = new ConnectionGuesser(
    [1,4,3,5,8,3,1,4,7,4],
    ["a","wise","man","makes","proverbs","but","a","fool","",""]
    );

my @seventh = 
(
 " i m o c(el) d2 n k2 e",
 ". p(ff) e r s2 v(w) i3 a2 n",
 " . . . s e2 h l2 d",
 ". . . . m n t u(oo) b(f)"
);

my $seventhg = new ConnectionGuesser(
    [4,3,5,5,3,5,6,6],
    ["wise","men","","","","fools","",""]
    );



my $tg = $seventhg;
my $ba = \@seventh;




my $cs =  new ConnectionState($ba);


my @queue;
push @queue,$cs;

while(@queue)
{
    my $qi = shift @queue;

    my $nq = $qi->Process($tg);
    push @queue,@$nq;
}



