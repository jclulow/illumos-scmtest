$HG -q clone $BASEWS $REPOS/clobber-rename-unco
cd $REPOS/clobber-rename-unco

$HG mv -f a b

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/clobber-rename-unco
