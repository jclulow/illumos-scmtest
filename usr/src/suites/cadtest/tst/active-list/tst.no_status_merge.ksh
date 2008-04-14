#
# We remove a file in the parent,
# clone a child at a point before that removal
# Modify that same file in the child
# bringover the removal
# merge (which is a conflict child mod v. parent removal), hg will default 'keep'
#
# This will mean the working context is modified (the merge) but contains no files.
# .files() and .status() will be blank
#


mkdir $REPOS/no-status-merge
$HG clone -q $BASEWS $REPOS/no-status-merge/parent
cd $REPOS/no-status-merge/parent
$HG rm c
$HG ci -m "Parent"

$HG clone -qr0 $REPOS/no-status-merge/parent $REPOS/no-status-merge/child
cd $REPOS/no-status-merge/child
echo c >> c
$HG ci -m "Child"
$HG pull -q $REPOS/no-status-merge/parent
$HG merge -q

echo "--- Uncommitted"
$HG list			# On failure, 'c' will show as modified, not added
echo "--- Committed"
$HG list
