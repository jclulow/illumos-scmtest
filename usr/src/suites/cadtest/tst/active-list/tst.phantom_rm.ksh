mkdir $REPOS/phantom-rm

$HG clone -q $BASEWS $REPOS/phantom-rm/parent
$HG clone -q $BASEWS $REPOS/phantom-rm/child

cd $REPOS/phantom-rm/parent
$HG mv a renamed
$HG ci -m "Rename"

cd $REPOS/phantom-rm/child
for i in c d e f; do
	echo $i >> $i
done
$HG ci -m "Modified"

$HG clone -q $REPOS/phantom-rm/child $REPOS/phantom-rm/merge
cd $REPOS/phantom-rm/merge

$HG pull -q $REPOS/phantom-rm/parent
$HG merge -q

echo "-- Uncommitted"
echo " -- Parent"
$HG list -p $REPOS/phantom-rm/parent
echo " -- Child"
$HG list -p $REPOS/phantom-rm/child
echo
echo "-- Committed"
echo " -- Parent"
$HG list -p $REPOS/phantom-rm/parent
echo " -- Child"
$HG list -p $REPOS/phantom-rm/child
