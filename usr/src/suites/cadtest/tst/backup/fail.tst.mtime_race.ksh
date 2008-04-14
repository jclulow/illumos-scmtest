#
# We want a committed change that doesn't change the size of a file
# and an uncommitted change that also doesn't change it.
#
# We want to catch the situation where the unbundle and diff in the
# restore happen within the granularity of the OS's mtime from stat(),
# such that Hg may miss the second change.
#

$HG clone -q $BASEWS $REPOS/bu-mtime-race
cd $REPOS/bu-mtime-race

sleep 1				# Don't want it here, obviously

echo cc > b			# change that'll be committed, retaining size, etc
$HG ci -m "Change"

sleep 1

echo dd > b			# Change that won't be committed, retaining size, etc

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/bu-mtime-race
