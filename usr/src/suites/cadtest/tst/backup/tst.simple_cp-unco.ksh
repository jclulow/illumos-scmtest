$HG -q clone $BASEWS $REPOS/simple-copy-unco
cd $REPOS/simple-copy-unco

$HG cp a unmodified
$HG cp b changed
echo "Changed file" >> changed

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/simple-copy-unco
