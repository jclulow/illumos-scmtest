$HG -q clone $BASEWS $REPOS/simple-mod-unco
cd $REPOS/simple-mod-unco

echo "With an extra line" >> a

sed -e 's/This/This here/' < b > b.tmp
mv b.tmp b

sed -e 's/././g' < c > c.tmp
mv c.tmp c

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/simple-mod-unco
