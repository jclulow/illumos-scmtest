#
# This is active-list/tst.no_status_merge.ksh (which see)
# We attempt to recommit after the file-less merge, to make sure it fails
#

$HG clone -qr0 $REPOS/no-status-merge/parent $REPOS/no-status-merge/reci-child
cd $REPOS/no-status-merge/reci-child
echo c >> c
$HG ci -m "Child"
$HG pull -q $REPOS/no-status-merge/parent
$HG merge -q

$HG reci -m "Recommit should fail" && exit 253 # This should fail, multiple heads
exit 0

