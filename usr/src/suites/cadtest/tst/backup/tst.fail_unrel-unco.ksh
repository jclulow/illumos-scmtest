#
# We use the workspace created by active-list/tst.simple-mod here
# purely such that our source workspace has a committed change that
# will not be included in the backup, and which the destination
# workspace (taken from $BASEWS) will not possess.
#

$HG clone -q $REPOS/simple-mod $REPOS/unrelated-unco
cd $REPOS/unrelated-unco

echo a >> a

$HG bu

$HG init $REPOS/unrelated-unco-restore
cd $REPOS/unrelated-unco-restore

#
# Should fail, as these two workspaces are unrelated.
# Even though there's no bundle to restore, we must still notice
#
$HG restore unrelated-unco 2>test.err
res=$?

sed -e "s/'[a-f0-9]\{12\}'/'<node>'/" test.err >&2

if [[ $res != 0 ]]; then
	exit 0
else
	exit 255
fi
