$HG clone -q $REPOS/basews $REPOS/localtags-needed
cd $REPOS/localtags-needed

$HG backup

# No change, should tell me so
($HG backup -t | grep 'backup is up-to-date') || exit 248

$HG tag -l needed-tag

# File is new created, should backup
($HG backup -t |grep 'backup is up-to-date') && exit 250

$HG tag -l other-needed-tag

# File changed, should backup
($HG backup -t | grep 'backup is up-to-date') && exit 252

rm .hg/localtags

# File removed, should backup
($HG backup -t | grep 'backup is up-to-date') && exit 254

exit 0				# So we don't exit as the grep above did
