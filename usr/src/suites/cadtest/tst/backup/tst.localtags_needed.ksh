$HG clone -q $REPOS/basews $REPOS/localtags-needed
cd $REPOS/localtags-needed

$HG backup

# No change, should tell me so
$HG backup -t >> backup.out.$$ || exit 248
/usr/xpg4/bin/grep -q 'backup is up-to-date' backup.out.$$|| exit 249

sleep 1				# mtime?

hg tag -l needed-tag

# File is new created, should backup
$HG backup -t || exit 250
/usr/xpg4/bin/grep -q 'backup is up-to-date' backup.out.$$ || exit 251

hg tag -l other-needed-tag

# File changed, should backup
$HG backup -t || exit 252
/usr/xpg4/bin/grep -q 'backup is up-to-date' backup.out.$$ || exit 253

rm .hg/localtags

# File removed, should backup
$HG backup -t || exit 254
/usr/xpg4/bin/grep -q 'backup is up-to-date' backup.out.$$ || exit 255

exit 0				# So we don't exit as the grep above did
