{ len=split($1,ary,//); asort(ary); r=""; for(i = 1 ; i <= len ; ++i) {r = r ary[i];} print $1,r; }
