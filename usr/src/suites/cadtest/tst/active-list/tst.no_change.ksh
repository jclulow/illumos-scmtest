$HG -q clone $BASEWS $REPOS/no-change
cd $REPOS/no-change

echo "-- Uncommitted"
$HG list
