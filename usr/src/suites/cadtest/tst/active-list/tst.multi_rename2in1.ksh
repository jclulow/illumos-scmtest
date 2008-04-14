$HG -q clone $BASEWS $REPOS/multi-rename2in1
cd $REPOS/multi-rename2in1

$HG mv a rename1
$HG mv -f rename1 b
$HG mv b rename2

echo "-- Uncommitted"
$HG list
echo "-- Committed"
$HG ci -m "Committed"
$HG list
