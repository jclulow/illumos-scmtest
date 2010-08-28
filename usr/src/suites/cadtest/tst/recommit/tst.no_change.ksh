cp -r $REPOS/no-change $REPOS/squish-no-change
cd $REPOS/squish-no-change

$HG reci -fm "Test Squish"  || true

