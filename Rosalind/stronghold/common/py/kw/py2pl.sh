perl -w py2y.pl "$1.py"
bison -v "$1.y"
rm -f *.tab.c
perl -w -d py.pl -rf $1
