#
# We create a situation whether there's nothing for us to recommit,
# but some local changes are below the parent tip.
#
# Such that when we do a strip-only reci, the 'safe' rev we go to is
# one that will be bundled and unbundled to keep it safe.
#

mkdir $REPOS/nul-change-merge
$HG clone -q $BASEWS $REPOS/nul-change-merge/parent
cd $REPOS/nul-change-merge/parent

echo d >> d
$HG ci -m "Change"

$HG clone -qr0 $REPOS/nul-change-merge/parent $REPOS/nul-change-merge/child
cd $REPOS/nul-change-merge/child

echo a >> a
$HG ci -m "One"
$HG cat -r0 a > a
$HG ci -m "Two"
$HG pull -q
$HG merge -q
$HG ci -m "Merge"

echo "--- Pre reci"
$HG list
$HG tip --template '{rev}\n{desc}\n' # Should be merge

$HG reci -qm "Test" 2> reci.stderr || (cat reci.stderr > /dev/stderr; exit 253)
echo

# Dump stderr back in, sans strip crud
grep -v '^saving bundle' reci.stderr > /dev/stderr

/usr/xpg4/bin/grep -q '^saving bundle' reci.stderr || exit 254

echo "--- Post reci"
$HG list 			# Should be blank
$HG tip --template '{rev}\n{desc}\n' # Should be 1 Change
$HG out -q && exit 255		     # Shouldn't be any
exit 0

