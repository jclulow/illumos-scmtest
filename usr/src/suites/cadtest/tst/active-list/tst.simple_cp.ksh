$HG -q clone $BASEWS $REPOS/simple-copy
cd $REPOS/simple-copy

$HG cp a unmodified
$HG cp b changed
echo "Changed file" >> changed

echo "-- Uncommitted"
$HG list
echo "-- Committed"
$HG ci -m "Committed"
$HG list
