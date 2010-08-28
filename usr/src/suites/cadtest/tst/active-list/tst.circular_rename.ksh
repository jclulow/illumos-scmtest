$HG -q clone $BASEWS $REPOS/circ-rename
cd $REPOS/circ-rename

$HG mv a renamed
$HG ci -m "Initial"
$HG mv renamed a

echo "-- Uncommitted"
$HG list
echo "-- Committed"
$HG ci -m "Committed"
$HG list
