$HG -q clone $BASEWS $REPOS/simple-squish
cd $REPOS/simple-squish

echo "more text" >> a
cp /dev/null b

$HG ci -m "Initial"

echo "and more text" >> a

echo "randmness" >> c

$HG ci -m "Second"

ksh $HARNESSDIR/tst/recommit/compare_reci.ksh $REPOS/simple-squish
