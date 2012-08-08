#!/bin/bash 

# start year and end year
SYEAR=2005
EYEAR=`date "+%Y"`

POSTPATH=~/Dropbox/projects/dev-xdworks/source/_posts/

echo
echo "YEAR      File #    Word Count"
echo "=============================="
for (( i=$SYEAR; i<=$EYEAR; i=i+1 ))
do
    NUMFILES=`ls -l $POSTPATH$i* 2> /dev/null | wc -l`
    NUMWORDS="       0"
    test $NUMFILES != "0" && NUMWORDS=`wc -m $POSTPATH$i-* | tail -n 1 | sed 's/ total//'`
    echo "$i    $NUMFILES      $NUMWORDS"
done
echo "=============================="
NUMFILES=`ls -1 $POSTPATH* | wc -l`
NUMWORDS=`wc -m $POSTPATH* | tail -n 1 | sed 's/ total//'`
echo "Total   $NUMFILES      $NUMWORDS"
echo