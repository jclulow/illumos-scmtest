cd $REPOS
$HG -q clone $BASEWS simple-rm
cd simple-rm
$HG rm d

echo "-- Uncommitted"
$HG list
echo "-- Committed"
$HG ci -m "Committed"
$HG list
