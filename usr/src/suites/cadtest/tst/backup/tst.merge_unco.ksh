$HG clone -q $BASEWS $REPOS/merge-unco
cd $REPOS/merge-unco

echo a >> a
$HG ci -m "Branch one"

$HG up -qC 0
echo b >> b
$HG ci -m "Branch two"

$HG merge -q

$HG backup && exit 254		# Should fail, uncommitted merge

$HG ci -m "Merge"

$HG backup || exit 255		# Should succeed, committed merge.
