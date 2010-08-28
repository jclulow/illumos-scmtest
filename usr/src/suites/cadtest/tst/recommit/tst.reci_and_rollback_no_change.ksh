#
# Make sure we don't allow a rollback that will corrupt the repo
#

$HG clone -q $BASEWS $REPOS/reci-and-rollback-no-change
cd $REPOS/reci-and-rollback-no-change

#
# These changes need to be a change, then a full revert Such that reci
# doesn't create a new changeset (which would have *new* undo data)
#
echo a >> a
$HG ci -m "Change"
$HG cat -r0 a > a
$HG ci -m "Revert change"

# Undo data must exist...
[[ -f .hg/store/undo ]] || exit 252

$HG reci -m "Reci" || exit 253

[[ -f .hg/store/undo ]] && exit 254

# Sadly, rollback doesn't return non-0 if it can't be accomplished
# We check for it doing what we want via the stderr comparison.
$HG rollback

$HG verify > /dev/null || exit 255 # Must succeed
