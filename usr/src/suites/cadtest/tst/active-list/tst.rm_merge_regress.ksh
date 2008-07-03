#
# This is a simulation of a set of changes in the Duckwater gate that
# caused cdm problems.  In certain cases involving a merge, we could
# lose removed files from the AL
#
# We create a parent workspace containing a modified file, and then an
# additional file.
#
# We then clone it at the modified file, to create the child.
#
# In the child, we modify another file, and commit, then we bringover
# the added file from the parent.
# 
# We make another change on top of that cset from the parent (another
# modified file) We then merge the two branches present in the child
# Before the merge is committed, we remove the file that the parent
# added.
#
# We then commit the merge and look at the AL
#
# In the bugged case, we will have lost the effective removal of the
# file the parent added.
# 

mkdir $REPOS/rm-merge-regress

#
# Parent contains a modified file, then an added file
#
$HG clone -q $REPOS/basews $REPOS/rm-merge-regress/parent
cd $REPOS/rm-merge-regress/parent

# Modify one file
echo a >> a
$HG ci -m "Modify"		# Revision 1

# Add another file
touch i
$HG add i
$HG ci -m "Add"			# Revision 2

echo "------ Parent first --------"

#
# Bringover a child containing only the modification, not the add (thus rev1)
#
# We then modify another file
# We bringover the added file from the parent (creating a second head)
# We update to that second head, and make another modification (we now
#   have two branches the heads of which are both local)
# We then merge the two heads, and, before committing the merge,
#   remove the file the parent added.

# Bringover parent at rev1
$HG clone -qr1 $REPOS/rm-merge-regress/parent $REPOS/rm-merge-regress/child
cd $REPOS/rm-merge-regress/child

# Make a local modification (our rev2, head of one branch)
echo c >> c
$HG ci -m "Local Modify"

# Bringover the added file from the parent (our rev3, head of second branch)
$HG pull -qr2 $REPOS/rm-merge-regress/parent

# Update to current tip (our rev3)
$HG up -qC tip

# Modify another file, commit (now head of second branch)
echo d >> d
$HG ci -m "Local Modify 2"	# Commit it (our rev4, head of second branch)

# Merge the two branches
$HG merge -q

# Remove the file that the parent added in its rev2, our rev3
$HG rm i
$HG ci -m "Commit"

$HG list

echo
echo "------ Local first --------"

#
# Bringover a second child containing only the modification, not the
# add (thus rev1), and do the above, but with the parent revisions of
# the merge in the opposite order.
#

# Bringover parent at rev1
$HG clone -qr1 $REPOS/rm-merge-regress/parent $REPOS/rm-merge-regress/child2
cd $REPOS/rm-merge-regress/child2

# Make a local modification (our rev2, head of one branch)
echo c >> c
$HG ci -m "Local Modify"

firsthead=$($HG parent --template '{rev}\n')

# Bringover the added file from the parent (our rev3, head of second branch)
$HG pull -qr2 $REPOS/rm-merge-regress/parent

# Update to current tip (our rev3)
$HG up -qC tip

# Modify another file, commit (now head of second branch)
echo d >> d
$HG ci -m "Local Modify 2"	# Commit it (our rev4, head of second branch)

$HG up -qC $firsthead

# Merge the two branches
$HG merge -q

# Remove the file that the parent added in its rev2, our rev3
$HG rm -f i
$HG ci -m "Commit"

$HG list
