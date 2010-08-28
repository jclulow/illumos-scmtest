mkdir $REPOS/merged-local-branches2

$HG clone -q $BASEWS $REPOS/merged-local-branches2/parent
cd $REPOS/merged-local-branches2/parent

echo "mod a" >> a
$HG ci -qm "Revision 1"
echo "mod b" >> b
$HG ci -qm "Revision 2"

$HG clone -q $REPOS/merged-local-branches2/parent $REPOS/merged-local-branches2/child
cd $REPOS/merged-local-branches2/child

#
# Create Nfiles branches, none of which conflict.
#
for i in *; do
	echo $i >> $i
	$HG ci -qm "Head $i"
	$HG up -qC $((RANDOM % 3))
done

#
# Merge them all
# 
$HG up -qC 3
for i in $($HG log -r4:tip --template '{rev}\n'); do
	HGMERGE=/bin/true $HG -q merge $i
	$HG ci -m "Merge $i"
done

ksh $HARNESSDIR/tst/recommit/compare_reci.ksh $REPOS/merged-local-branches2/child
