$HG clone -q $BASEWS $REPOS/no-change
cd $REPOS/no-change

$HG pbchk || exit 255

