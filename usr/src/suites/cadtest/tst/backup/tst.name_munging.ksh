#
# Create a workspace with a name that should be munged into something
# useful by the backup code.  Then take a backup and make sure it's
# munged as specified
#

mkdir -p $REPOS/munged-name/usr
$HG clone -q $BASEWS $REPOS/munged-name/usr/closed
cd $REPOS/munged-name/usr/closed

echo a >> a			# Just need some kind of change
$HG bu

# The name should have been munged into the backupdir like so.
[[ -d $BACKUPDIR/munged-name-closed ]] || exit 254

$HG ci -m "Random"		# Need to commit so we can recommit
$HG reci -ym "Random"		# Recommit, which will need to take a backup.

# If the non-munged name exists as a backup, we've failed.
if [[ -d $BACKUPDIR/closed ]]; then
	exit 255
else
	exit 0
fi

