$HG -q clone $BASEWS $REPOS/simple-rename-unco
cd $REPOS/simple-rename-unco

$HG mv a unmodified
$HG mv b changed
echo "Changed file" >> changed

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/simple-rename-unco
