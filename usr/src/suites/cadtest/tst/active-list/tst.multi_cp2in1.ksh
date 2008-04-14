$HG -q clone $BASEWS $REPOS/multi-cp2in1
cd $REPOS/multi-cp2in1

$HG cp a rename1
$HG cp -f rename1 b
$HG cp b rename2

echo "-- Uncommitted"
$HG list
echo "-- Committed"
$HG ci -m "Committed"
$HG list
