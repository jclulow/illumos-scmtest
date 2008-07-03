if [[ -z "$1" ]]; then
	print -u2 "Usage: compare_bu_restore.ksh <workspace>"
	exit 2
fi

ORIG_REPO=$1
BACKUP_NAME=$(basename $1)
RESTORE_REPO=${1}-restore

cd $ORIG_REPO

$HG backup || exit 248		# Should succeed

$HG -q clone $BASEWS $RESTORE_REPO
cd $RESTORE_REPO

$HG restore $BACKUP_NAME || exit 249 # Should succeed

gdiff -rux .hg $ORIG_REPO $RESTORE_REPO || exit 250

$HG -R $ORIG_REPO list > orig.out.$$
$HG -R $RESTORE_REPO list > restore.out.$$

cmp orig.out.$$ restore.out.$$ || exit 251

cmp $ORIG_REPO/.hg/hgrc $RESTORE_REPO/.hg/hgrc || exit 252

if [[ -f $ORIG_REPO/.hg/localtags ]]; then
	cmp $ORIG_REPO/.hg/localtags $RESTORE_REPO/.hg/localtags || exit 253
fi
	
$HG -R $ORIG_REPO status -C | egrep -v '\? (orig|restore).*' > orig-stat.out.$$ 
$HG -R $RESTORE_REPO status -C | egrep -v '\? (orig|restore).*' > restore-stat.out.$$

cmp orig-stat.out.$$ restore-stat.out.$$ || exit 254

(cd $ORIG_REPO && stat --printf="%n %a %A %F %N\n" *) > orig-fsstat.out.$$
(cd $RESTORE_REPO && stat --printf="%n %a %A %F %N\n" * | grep -v '\.out\.') > restore-fsstat.out.$$

cmp orig-fsstat.out.$$ restore-fsstat.out.$$ || exit 255


