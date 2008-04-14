$HG -q clone $BASEWS $REPOS/simple-add-unco
cd $REPOS/simple-add-unco

touch i
$HG add i

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/simple-add-unco
