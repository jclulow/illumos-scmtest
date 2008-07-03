#
# Make sure that the AL sees both sides of an uncommitted merge
#

$HG clone -q $BASEWS $REPOS/unco_merge_regress
cd $REPOS/unco_merge_regress

$HG mv a new-a
$HG ci -qm "One"

$HG cp b new-b
$HG ci -qm "Two"

$HG rm c
$HG ci -qm "Three"

touch new-1
$HG add new-1
$HG ci -qm "Four"


$HG up -qC 0


$HG mv d new-d
$HG ci -qm "Five"

$HG cp e new-e
$HG ci -qm "Six"

$HG rm f
$HG ci -qm "Seven"

touch new-2
$HG add new-2
$HG ci -qm "Eight"

$HG up -qC 4

$HG merge -q

echo "--- Uncommitted"
$HG list
