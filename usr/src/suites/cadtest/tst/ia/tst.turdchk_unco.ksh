#
# This is active-list/tst.no_status_merge.ksh (which see)
# We merge in a new child, and attempt to pbchk the merge (which, in the worst
# case)
#

$HG clone -qr0 $REPOS/no-status-merge/parent $REPOS/no-status-merge/ia-child
cd $REPOS/no-status-merge/ia-child
echo c >> c
$HG ci -m "Child"
$HG pull -q $REPOS/no-status-merge/parent
$HG merge -q

$HG pbchk -qN
RES=$?

#
# Should exit with 3.
# This is because cddlchk will warn about the new file 'c' not having a CDDL,
# cddlchk returns 2 for warnings, thus we end up doing 2|1 == 3
#
if [[ $RES -ne 3 ]]; then
	print -u2 "Exited with $RES instead of 1"
	exit 255
else
	exit 0
fi
