$HG -q clone $BASEWS $REPOS/circ-rename-unco
cd $REPOS/circ-rename-unco

$HG mv a renamed
$HG ci -m "Initial"
$HG mv renamed a

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/circ-rename-unco
