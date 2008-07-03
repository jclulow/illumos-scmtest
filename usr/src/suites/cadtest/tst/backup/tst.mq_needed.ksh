$HG clone -q $REPOS/basews $REPOS/mq-needed
cd $REPOS/mq-needed

$HG backup

# No change, should tell me so
($HG backup -t | grep 'backup is up-to-date') || exit 248

$HG qinit

# Patch queue is new, should backup
($HG backup -t | grep 'backup is up-to-date') && exit 250

$HG qnew -g foo-diff
echo a >> a
$HG qrefresh
$HG qpop

# Patch created, should backup
($HG backup -t | grep 'backup is up-to-date') && exit 252

$HG qdelete foo-diff

# Patch removed, should backup
($HG backup -t grep 'backup is up-to-date') && exit 254

exit 0				# So we don't exit as the grep above did
