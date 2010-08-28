$HG clone -q $BASEWS $REPOS/chmod-only-unco
cd $REPOS/chmod-only-unco

chmod +x a

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/chmod-only-unco
