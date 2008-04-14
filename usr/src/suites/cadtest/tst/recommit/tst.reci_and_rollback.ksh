#
# Make sure we don't allow a rollback that will corrupt the repo
#

$HG clone -q $BASEWS $REPOS/reci-and-rollback
cd $REPOS/reci-and-rollback

#
# We make a non-cylic change, so we know that we clear the undo
# even after we do a real commit (compare to no_change).#

echo a >> a
$HG ci -m "Change"
echo b >> b
$HG ci -m "Revert change"

# Undo data must exist...
[[ -f .hg/store/undo ]] || exit 252

# Excuse the nastyness with stderr...
$HG reci -m "Reci" 2>reci.stderr || (cat reci.stderr > /dev/stderr; exit 253)
grep -v '^saving bundle' reci.stderr > /dev/stderr

[[ -f .hg/store/undo ]] && exit 253

# Sadly, rollback doesn't return non-0 if it can't be accomplished
# We check for it doing what we want via the stderr comparison.
$HG rollback

$HG verify > /dev/null || exit 255 # Must succeed
