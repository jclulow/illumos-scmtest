cp -r $REPOS/simple-branch $REPOS/squish-simple-branch1
cd $REPOS/squish-simple-branch1

# With multiple heads, this must fail.
$HG reci -fm "Test Squish" || true
