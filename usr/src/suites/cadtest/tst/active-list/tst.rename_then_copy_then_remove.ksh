$HG -q clone $BASEWS $REPOS/rename-then-cp-then-rm
cd $REPOS/rename-then-cp-then-rm

$HG mv a renamed
$HG ci -m "rename 1"
$HG cp renamed copied
$HG ci -m "copy 1"
$HG rm renamed

echo "-- Uncommitted"
$HG list
echo "-- Committed"
$HG ci -m "Committed"
$HG list
