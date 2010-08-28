$HG -q clone $BASEWS $REPOS/multi-rename1
cd $REPOS/multi-rename1

$HG mv a rename1
$HG mv b rename2
$HG ci -m "One"
$HG rm rename1
$HG ci -m "Two"
$HG mv rename2 rename1

echo "-- Uncommitted"
$HG list
echo "-- Committed"
$HG ci -m "Committed"
$HG list
