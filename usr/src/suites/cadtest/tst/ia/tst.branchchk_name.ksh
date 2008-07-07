# Make sure we fail if the branch name isn't 'default'

$HG clone -q $BASEWS $REPOS/branchchk-name
cd $REPOS/branchchk-name

$HG branch -q look-at-me-im-special
echo a >> a
$HG ci -qm "Change branch name"

$HG branchchk && exit 254 	# Should fail, wrong branch name

echo
$HG branch -qf default		# Fix the branch
$HG ci -m "Reset branch"
$HG reci -m "Reset" 		# Reci to make the created branch truly go away

echo
$HG branchchk || exit 255	# Should succeed this time.
