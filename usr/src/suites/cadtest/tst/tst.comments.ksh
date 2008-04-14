$HG -q clone $BASEWS $REPOS/comments
cd $REPOS/comments

echo "foo" >> a

$HG ci -m "Foo bar baz
1111111 Bug Id
PSARC 2007/125 ARC Case
2222222 Other Bug ID"

echo "--- Comments"
$HG comments
echo "--- Bugs"
$HG bugs
echo "--- ARCs"
$HG arcs
