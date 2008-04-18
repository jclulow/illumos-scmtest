$HG clone -q $REPOS/basews $REPOS/content-needed
cd $REPOS/content-needed

$HG backup

# No change, should tell me so
($HG backup -t | grep 'backup is up-to-date') || exit 250

echo "b" >> a

($HG backup -t | grep 'backup is up-to-date') && exit 251

$HG ci -m "Commit"

# Should be needed for committed change
($HG backup -t | grep 'backup is up-to-date') && exit 251

exit 0				# So we don't exit as the grep above did
