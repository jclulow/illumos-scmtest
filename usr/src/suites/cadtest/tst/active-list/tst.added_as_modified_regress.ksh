#
# This is a regression test for a bug in the initial implementation of
# #415/#416 (from cset onnv-scm:e4c2a816dd66).
#
# In the case where the parent and child are merged in a dedicated
# workspace, with ancestry thus:
#
#   parent -> child -> merge
#
# Where a change in the parent containing an addition is being merged
# into child in the merge workspace 'hg st', and ActiveList._build see
# the status of the added file as 'modified', and would thus attempt
# to filecmp it, based on its version in the parenttip (where it does
# not exist), crashing out the AL build.
#
# We need to check ourselves whether the file is present in the
# parenttip, and if it is not, force its status to 'added', to avoid
# this (and avoid further problems).
#

mkdir $REPOS/add-as-mod-regress

#
# Parent workspace has one revision modify a file, a second add a
# file.
#
$HG clone -q $REPOS/basews $REPOS/add-as-mod-regress/parent
cd $REPOS/add-as-mod-regress/parent

echo a >> a
$HG ci -m "Modify"    # revision 1
touch new_file
$HG add new_file
$HG ci -m "Add file"  # revision 2

# Child workspace is a clone of the parent, after the modified file
# Child has a modified file of its own
$HG clone -qr1 $REPOS/add-as-mod-regress/parent $REPOS/add-as-mod-regress/child
cd $REPOS/add-as-mod-regress/child

echo b >> b
$HG ci -m "Local modify"	# our rev 2

# Bringover a grandchild to perform the merge in
$HG -q clone $REPOS/add-as-mod-regress/child $REPOS/add-as-mod-regress/merge
cd $REPOS/add-as-mod-regress/merge

# Bringover and merge r2 from the parent (the added file)
$HG pull -q $REPOS/add-as-mod-regress/parent
$HG merge

# On failure, this will crash unable to find 'new_file' in the parent
# tip manifest
$HG list --traceback || exit 253

# And with it committed
$HG ci -m "Commit"

$HG list --traceback || exit 254
