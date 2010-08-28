$HG -q clone $BASEWS $REPOS/simple-rm-unco
cd $REPOS/simple-rm-unco

$HG rm d

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/simple-rm-unco
