cd $REPOS/simple-branch

$HG up -C 1 > /dev/null 2>&1
ksh $HARNESSDIR/tst/pdiff/constant_pdiff.ksh $REPOS/simple-branch
