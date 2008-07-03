cd $REPOS
$HG -q clone $BASEWS simple-branch
cd simple-branch

echo "foo" >> a
$HG ci -qm "Head 1"

$HG up -qC 0 > /dev/null
echo "bar" >> b

echo "--- Second Branch"

echo "-- Uncommitted"
$HG list
echo "-- Committed"
$HG ci -qm "Head 2"
$HG list

echo "-- Comments"
$HG comments

echo "--- Other Branch"
$HG up -qC 1 > /dev/null

echo "-- Committed"
$HG list

echo "-- Comments"
$HG comments

echo "--- No Branch"
$HG up -qC 0 > /dev/null

echo "-- Committed"
$HG list

echo "-- Comments"
$HG comments
