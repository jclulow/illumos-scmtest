if [[ -z "$1" ]]; then
	print -u2 "Usage: compare_reci.ksh <workspace>"
	exit 2
fi

ORIG_REPO=$1
RECI_REPO=${1}-reci

cp -rP $ORIG_REPO $RECI_REPO 
cd $RECI_REPO

$HG reci -fm "Test Squish" || exit 252

gdiff -rux .hg $ORIG_REPO $RECI_REPO || exit 253

$HG -R $ORIG_REPO list > orig.out.$$
$HG -R $RECI_REPO list > squish.out.$$

cmp orig.out.$$ squish.out.$$ || exit 254

(cd $ORIG_REPO && stat --printf="%n %a %A %F %N\n" *) > orig-fsstat.out.$$
(cd $RECI_REPO && stat --printf="%n %a %A %F %N\n" * | grep -v '\.out\.') > restore-fsstat.out.$$

cmp orig-fsstat.out.$$ restore-fsstat.out.$$ || exit 255
