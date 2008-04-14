$HG -q clone $BASEWS $REPOS/multi-cp2-unco
cd $REPOS/multi-cp2-unco

$HG cp a rename1
$HG ci -m "One"
$HG cp -f rename1 b
$HG ci -m "Two"
$HG cp b rename2

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/multi-cp2-unco
