$HG -q clone $BASEWS $REPOS/simple-rename
cd $REPOS/simple-rename

$HG mv a unmodified
$HG mv b changed
echo "Changed file" >> changed

echo "-- Uncommitted"
$HG list
echo "-- Committed"
$HG ci -m "Committed"
$HG list
