#
# Create a set of changes that don't change anything, then recommit them.
#

$HG clone -q $BASEWS $REPOS/nul-change
cd $REPOS/nul-change

# Make changes

echo "a" > a
$HG ci -m "Change a"
$HG mv b new_b
$HG ci -m "Rename b"
$HG rm c
$HG ci -m "Remove c"
touch new-file
$HG add new-file
$HG ci -m "Add new-file"

# Unmake changes
hg cat -r0 a > a
$HG ci -m "Unchange a"
$HG mv new_b b
$HG ci -m "Unrename b"
$HG cat -r0 c > c
$HG add c
$HG ci -m "Unremove c"
$HG rm new-file
$HG ci -m "Unadd new-file"

echo "--- Pre reci"
$HG list			     # Should be blank
$HG tip --template '{rev}\n{desc}\n'  # Should be Unadd new-file
$HG reci -m "Recommit" || exit 254

echo "--- Post reci"
$HG list			     # Should still be blank
$HG tip --template '{rev}\n{desc}\n' # Should be rev 0
$HG out -q && exit 255		     # Shouldn't be any
exit 0
