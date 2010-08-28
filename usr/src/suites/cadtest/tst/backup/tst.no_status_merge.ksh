#
# This is active-list/tst.no_status_merge.ksh (which see)
# We attempt to restore a backup into this, which should fail because of the
# in-progress merge.
#

$HG clone -qr0 $REPOS/no-status-merge/parent $REPOS/no-status-merge/restore-child
cd $REPOS/no-status-merge/restore-child
echo c >> c
$HG ci -m "Child"
$HG pull -q $REPOS/no-status-merge/parent
$HG merge -q

#
# Try and restore from a preceeding workspace,
# this should fail, workspace is already modified
#
$HG restore circular-rename && exit 255
exit 0
