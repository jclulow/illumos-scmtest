$HG -q clone $BASEWS $REPOS/simple-branch-unco
cd $REPOS/simple-branch-unco

# Backup and restore a workspace where the restore should create an
# uncommitted second head

echo "foo" >> a
$HG ci -m "Head 1"

$HG up -C 0 > /dev/null
echo "bar" >> b

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/simple-branch-unco
