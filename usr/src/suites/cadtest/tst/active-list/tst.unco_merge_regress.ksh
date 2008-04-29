#
# Make sure that the AL sees both sides of an uncommitted merge
#

$HG clone -q $BASEWS $REPOS/unco_merge_regress
cd $REPOS/unco_merge_regress

$HG mv a new-a
$HG ci -m "One"

$HG cp b new-b
$HG ci -m "Two"

$HG rm c
$HG ci -m "Three"

touch new-1
$HG add new-1
$HG ci -m "Four"


$HG up -qC 0


$HG mv d new-d
$HG ci -m "Five"

$HG cp e new-e
$HG ci -m "Six"

$HG rm f
$HG ci -m "Seven"

touch new-2
$HG add new-2
$HG ci -m "Eight"

$HG up -qC 4

$HG merge -q

echo "--- Uncommitted"
$HG list
