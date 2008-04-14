cp -r $REPOS/simple-rename $REPOS/squish-rename-copy-regress
cd $REPOS/squish-rename-copy-regress

touch a b			# create the source halves of the rename

#
# NB: hackity hack, sending stderr to stdout here allows us to use the
#   output comparison to trip if the bogus file list isn't what we
#   expect.  Obviously, this relies on *nothing else* going to stdout,
#   unless in situations where we'd otherwise fail...
#
$HG reci -m "Test Squish" 2>&1 && exit 250 # This should fail, because we default to "No"

gdiff -rux .hg --unidirectional-new-file $REPOS/simple-rename \
	$REPOS/squish-rename-copy-regress || exit 251

$HG -R $REPOS/simple-rename list > no.orig.out.$$
$HG -R $REPOS/squish-rename-copy-regress list > no.squish.out.$$

cmp no.orig.out.$$ no.squish.out.$$ || exit 252
