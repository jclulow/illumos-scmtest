$HG -q clone $BASEWS $REPOS/multi-cp2
cd $REPOS/multi-cp2

$HG cp a rename1
$HG ci -m "One"
$HG cp -f rename1 b
$HG ci -m "Two"
$HG cp b rename2

echo "-- Uncommitted"
$HG list
echo "-- Committed"
$HG ci -m "Committed"
$HG list
