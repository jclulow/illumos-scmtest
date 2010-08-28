$HG clone -q $REPOS/basews $REPOS/hgrc-needed
cd $REPOS/hgrc-needed

$HG backup

# No change, should tell me so
($HG backup -t | grep 'backup is up-to-date') || exit 250

# The only thing in there will be the [paths] section, so add another path
echo "foo = bar" >> .hg/hgrc

# Size changed, should backup
($HG backup -t | grep 'backup is up-to-date') && exit 251

sleep 1

# Only mtime and contents changed
sed -e '$s/bar$/foo/' < .hg/hgrc > .hg/hgrc.tmp && mv .hg/hgrc.tmp .hg/hgrc

# mtime changed, should backup
($HG backup -t | grep 'backup is up-to-date') && exit 252

exit 0				# So we don't exit as the grep above did
