$HG -q clone $BASEWS $REPOS/rename-then-rm
cd $REPOS/rename-then-rm

$HG mv a renamed
$HG ci -m "rename 1"
$HG mv renamed rename-again
$HG ci -m "rename 2"
$HG mv rename-again rename-yet-more
$HG ci -m "rename 3"
$HG rm rename-yet-more

echo "-- Uncommitted"
$HG list
echo "-- Committed"
$HG ci -m "Committed"
$HG list
