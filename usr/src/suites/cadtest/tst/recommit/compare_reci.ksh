if [[ -z "$1" ]]; then
	print -u2 "Usage: compare_reci.ksh <workspace>"
	exit 2
fi

ORIG_REPO=$1
RECI_REPO=${1}-reci

cp -r $ORIG_REPO $RECI_REPO 
cd $RECI_REPO

$HG reci -fm "Test Squish" || exit 253

gdiff -rux .hg $ORIG_REPO $RECI_REPO || exit 254

$HG -R $ORIG_REPO list > orig.out.$$
$HG -R $RECI_REPO list > squish.out.$$

cmp orig.out.$$ squish.out.$$ || exit 255
