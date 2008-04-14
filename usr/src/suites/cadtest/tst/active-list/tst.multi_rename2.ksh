$HG -q clone $BASEWS $REPOS/multi-rename2
cd $REPOS/multi-rename2

$HG mv a rename1
$HG ci -m "One"
$HG mv -f rename1 b
$HG ci -m "Two"
$HG mv b rename2
#$HG ci -m "Three"
#$HG mv rename2 rename1

echo "-- Uncommitted"
$HG list
echo "-- Committed"
$HG ci -m "Committed"
$HG list
