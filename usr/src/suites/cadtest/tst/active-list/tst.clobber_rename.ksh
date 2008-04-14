$HG -q clone $BASEWS $REPOS/clobber-rename
cd $REPOS/clobber-rename

$HG mv -f a b

echo "-- Uncommitted"
$HG list
echo "-- Committed"
$HG ci -m "Committed"
$HG list
