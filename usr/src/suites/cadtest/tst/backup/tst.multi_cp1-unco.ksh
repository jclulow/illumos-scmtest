$HG -q clone $BASEWS $REPOS/multi-cp1-unco
cd $REPOS/multi-cp1-unco

$HG cp a rename1
$HG cp b rename2
$HG ci -m "One"
$HG rm rename1
$HG ci -m "Two"
$HG cp rename2 rename1

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/multi-cp1-unco
