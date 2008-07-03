$HG clone -q $REPOS/basews $REPOS/clobber-needed
cd $REPOS/clobber-needed

$HG backup

# No change, should tell me so
($HG backup -t | grep 'backup is up-to-date') || exit 248

sleep 1				# mtime?

$HG cp -f a b
echo a > b

# Needs a backup, diff changed, clobber changed
($HG backup -t | grep 'backup is up-to-date') && exit 249

$HG cp -f c b
echo a > b

# Needs a backup, clobber changed
($HG backup -t | grep 'backup is up-to-date') && exit 250

exit 0				# So we don't exit as the grep above did
