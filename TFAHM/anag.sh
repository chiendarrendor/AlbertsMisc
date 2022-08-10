#! /bin/sh

PROBE=`echo $1 | awk -f sortrec.awk | awk '{print $2}'`
cat collinswords2019.txt | awk -f sortrec.awk | grep ' '$PROBE'$' | awk '{print $1}'
