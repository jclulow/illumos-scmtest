$HG clone -q $BASEWS $REPOS/newbranch-unco
cd $REPOS/newbranch-unco

echo a >> a
$HG ci -m "Change"

$HG branch -q foo

$HG reci -m "Test" && exit 255

exit 0
