$HG clone -q $BASEWS $REPOS/newbranch-prop
cd $REPOS/newbranch-prop

echo a >> a
$HG ci -m "Change"

$HG branch -q foo
$HG ci -qm "New branch"

ksh $HARNESSDIR/tst/recommit/compare_reci.ksh $REPOS/newbranch-prop

