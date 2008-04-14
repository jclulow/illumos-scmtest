$HG -q clone $BASEWS $REPOS/multi-rename2-unco
cd $REPOS/multi-rename2-unco

$HG mv a rename1
$HG ci -m "One"
$HG mv -f rename1 b
$HG ci -m "Two"
$HG mv b rename2

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/multi-rename2-unco
