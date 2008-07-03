cp -r $REPOS/simple-mod $REPOS/squish-tags
cd $REPOS/squish-tags

echo a >> a
$HG ci -m "Random change"

$HG tag -r0 repokeep
$HG tag -lr0 localkeep
$HG tag -r tip repoflush
$HG tag -lr tip localflush
$HG tag -r0 repooverkeep
$HG tag -lr0 localoverkeep
$HG tag -fr tip repooverkeep
$HG tag -flr tip localoverkeep

$HG reci -m "Test squish" > squish.out.$$ || exit 254

# Nodes vary
sed -e 's/\([0-9]\{1,\}\):[^ ]\{1,\}/\1/' squish.out.$$

# Make sure the tags are really gone
if grep -v 'keep$' .hgtags .hg/localtags; then
	exit 1;
else
	exit 0;
fi
