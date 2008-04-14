$HG clone -q $BASEWS $REPOS/renamed-add
cd $REPOS/renamed-add

echo "new" > new
$HG add new
$HG ci -m "Initial"
$HG mv new new-rename
$HG ci -m "Rename one"
$HG mv new-rename newer-rename
$HG ci -m "Rename two"

$HG list
