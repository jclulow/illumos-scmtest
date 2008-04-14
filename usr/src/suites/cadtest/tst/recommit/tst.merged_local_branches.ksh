#
# A given workspace may contain N local branches, all with their
# ancestry in the parent that are then merged to the local tip (or
# somepoint behind it).
#
# This is pretty tricky for recommit, so we try such things and see if
# we can't trip it up.
#

$HG clone -q $BASEWS $REPOS/merged-local-branches
cd $REPOS/merged-local-branches

#
# Create Nfiles branches, none of which conflict.
#
for i in *; do
	echo $i >> $i
	$HG ci -m "Head $i"
	hg up -qC 0
done

#
# Merge them all
# 
hg up -qC 1
for i in $(hg log -r2:tip --template '{rev}\n'); do
	hg -q merge $i
	hg ci -m "Merge $i"
done

ksh $HARNESSDIR/tst/recommit/compare_reci.ksh $REPOS/merged-local-branches
