$HG -q clone $BASEWS $REPOS/multi-rename2in1-unco
cd $REPOS/multi-rename2in1-unco

$HG mv a rename1
$HG mv -f rename1 b
$HG mv b rename2

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/multi-rename2in1-unco
