#
# Test for reci -u, which allows you to pose as someone you're not.
#

$HG clone -q $BASEWS $REPOS/pose-as-others
cd $REPOS/pose-as-others

echo a >> a
$HG ci -u "someone" -m "Test"	# So we know what it shouldn't be

$HG reci -u "Random User" -m "Test reci"

($HG tip --template '{author}' | grep "Random User") || exit 255
