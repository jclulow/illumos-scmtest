$HG -q clone $BASEWS $REPOS/multi-cp1
cd $REPOS/multi-cp1

$HG cp a rename1
$HG cp b rename2
$HG ci -m "One"
$HG rm rename1
$HG ci -m "Two"
$HG cp rename2 rename1

echo "-- Uncommitted"
$HG list
echo "-- Committed"
$HG ci -m "Committed"
$HG list
