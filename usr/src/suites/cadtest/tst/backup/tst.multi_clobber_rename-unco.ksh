$HG clone -q $BASEWS $REPOS/multi-clobber-rename-unco

cd $REPOS/multi-clobber-rename-unco
$HG mv -f a b
$HG mv -f c d

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/multi-clobber-rename-unco
