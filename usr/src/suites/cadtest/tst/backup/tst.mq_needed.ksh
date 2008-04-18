$HG clone -q $REPOS/basews $REPOS/mq-needed
cd $REPOS/mq-needed

$HG backup

# No change, should tell me so
$HG backup -t >> backup.out.$$ || exit 248
/usr/xpg4/bin/grep -q 'backup is up-to-date' backup.out.$$|| exit 249

sleep 1				# mtime?

hg qinit

# Patch queue is new, should backup
$HG backup -t || exit 250
/usr/xpg4/bin/grep -q 'backup is up-to-date' backup.out.$$ || exit 251

hg qnew -g foo-diff
echo a >> a
hg qrefresh
hg qpop

# Patch created, should backup
$HG backup -t || exit 252
/usr/xpg4/bin/grep -q 'backup is up-to-date' backup.out.$$ || exit 253

hg qdelete foo-diff

# Patch removed, should backup
$HG backup -t || exit 254
/usr/xpg4/bin/grep -q 'backup is up-to-date' backup.out.$$ || exit 255

exit 0				# So we don't exit as the grep above did
