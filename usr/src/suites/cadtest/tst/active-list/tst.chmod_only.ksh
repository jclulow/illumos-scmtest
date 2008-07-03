$HG clone -q $BASEWS $REPOS/chmod-only
cd $REPOS/chmod-only

chmod +x a

echo "--- Uncommitted"
$HG list
$HG ci -m "Committed"
echo "--- Committed"
$HG list
