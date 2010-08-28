$HG -q clone $BASEWS $REPOS/two-clobber-rename-unco
cd $REPOS/two-clobber-rename-unco

$HG mv -f a b
$HG mv -f c b

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/two-clobber-rename-unco
