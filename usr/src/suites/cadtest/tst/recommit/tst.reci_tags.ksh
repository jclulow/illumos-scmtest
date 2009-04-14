cp -r $REPOS/simple-mod $REPOS/squish-tags
cd $REPOS/squish-tags

echo a >> a
$HG ci -m "Random change"


# Tags that should remain
$HG tag -r0 repokeep
$HG tag -r0 'repo with spaces keep'
$HG tag -lr0 localkeep
$HG tag -lr0 'local with spaces keep'

# Tags that should be removed
$HG tag -r tip repoflush
$HG tag -r tip 'repo with spaces flush'
$HG tag -lr tip 'local with spaces flush'
$HG tag -lr tip localflush

# Multiply defined tags (earlier definition, should remain)  
$HG tag -r0 repooverkeep
$HG tag -r0 'repo over space keep'
$HG tag -lr0 localoverkeep
$HG tag -lr0 'local over space keep'

# Multiply defined tags (later definition, should be removed)
$HG tag -fr tip repooverkeep
$HG tag -fr tip 'repo over space keep'
$HG tag -flr tip localoverkeep
$HG tag -flr tip 'local over space keep'

$HG reci -m "Test squish" > squish.out.$$ || exit 254

# Nodes vary
sed -e 's/\([0-9]\{1,\}\):[^:]\{1,\}/\1/' squish.out.$$
echo
echo "Erroneously remaining tags:"
# Make sure the tags are really gone
grep -v 'keep$' .hgtags .hg/localtags && exit 1

echo
echo "Remaining tags:"
# Make sure tags that should remain, do
$HG tags | sed -e 's/:.*$//'
