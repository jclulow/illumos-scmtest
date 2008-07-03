# We can't re-use the link-only WS from the active-list test here, as
# the file we used to make it such that contents were identical isn't
# controlled, and thus wouldn't stay.
#
# We'll pick something else, here

$HG clone -q $BASEWS $REPOS/link-backup
cd $REPOS/link-backup

rm a
ln -s /etc/system a
$HG ci -m "Link only"

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/link-backup
