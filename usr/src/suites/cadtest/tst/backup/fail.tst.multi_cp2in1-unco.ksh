$HG -q clone $BASEWS $REPOS/multi-cp2in1-unco
cd $REPOS/multi-cp2in1-unco

$HG cp a rename1
$HG cp -f rename1 b
$HG cp b rename2

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/multi-cp2in1-unco
