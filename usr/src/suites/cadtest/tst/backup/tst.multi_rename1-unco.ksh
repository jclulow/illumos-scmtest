$HG -q clone $BASEWS $REPOS/multi-rename1-unco
cd $REPOS/multi-rename1-unco

$HG mv a rename1
$HG mv b rename2
$HG ci -m "One"
$HG rm rename1
$HG ci -m "Two"
$HG mv rename2 rename1

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/multi-rename1-unco
