$HG clone -q $BASEWS $REPOS/link-only
cd $REPOS/link-only

mv a other-a
ln -s other-a a

echo "--- Uncommitted"
$HG list
$HG ci -m "Committed"
echo "--- Committed"
$HG list
