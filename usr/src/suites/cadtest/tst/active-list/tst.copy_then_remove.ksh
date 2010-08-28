$HG -q clone $BASEWS $REPOS/cp-then-rm
cd $REPOS/cp-then-rm

$HG cp a copied
$HG ci -m "rename 1"
$HG rm copied

echo "-- Uncommitted"
$HG list
echo "-- Committed"
$HG ci -m "Committed"
$HG list
