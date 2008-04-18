$HG -q clone $BASEWS $REPOS/rename-twice
cd $REPOS/rename-twice

$HG cp a rename1
$HG cp a rename2
$HG rm a

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/rename-twice
