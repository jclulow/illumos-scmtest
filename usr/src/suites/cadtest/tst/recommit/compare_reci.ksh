if [[ -z "$1" ]]; then
	print -u2 "Usage: compare_reci.ksh <workspace>"
	exit 2
fi

ORIG_REPO=$1
RECI_REPO=${1}-reci

cp -rP $ORIG_REPO $RECI_REPO 
cd $RECI_REPO

$HG reci -fm "Test Squish" || exit 251

gdiff -rux .hg $ORIG_REPO $RECI_REPO || exit 252

$HG -R $ORIG_REPO list > orig.out.$$
$HG -R $RECI_REPO list > squish.out.$$

$HG branch -R $ORIG_REPO > orig-branch.out.$$
$HG branch -R $RECI_REPO > squish-branch.out.$$

cmp orig.out.$$ squish.out.$$ || exit 253
cmp orig-branch.out.$$ squish-branch.out.$$ || exit 254

(cd $ORIG_REPO && stat --printf="%n %a %A %F %N\n" *) > orig-fsstat.out.$$
(cd $RECI_REPO && stat --printf="%n %a %A %F %N\n" * | grep -v '\.out\.') > squish-fsstat.out.$$

cmp orig-fsstat.out.$$ squish-fsstat.out.$$ || exit 255
