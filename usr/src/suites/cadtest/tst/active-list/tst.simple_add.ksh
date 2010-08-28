cd $REPOS
$HG -q clone $BASEWS simple-add
cd simple-add

touch i
$HG add i

echo "-- Uncommitted"
$HG list
echo "-- Committed"
$HG ci -m "Committed"
$HG list
