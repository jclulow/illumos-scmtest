$HG -q clone $BASEWS $REPOS/revert-unco
cd $REPOS/revert-unco

# a - modified, reverted
# b - modified, renamed, modification reverted
# c - modified, renamed, both reverted
# d - modified, renamed, rename reverted

for i in a b c d; do
	sed -e 's/This/.../' < $i > $i.tmp
	mv $i.tmp $i
done

$HG mv b b.new
$HG mv c c.new
$HG mv d d.new

$HG ci -m "Initial"

for i in a b.new c.new; do
	sed -e 's/\.\.\./This/' < $i > $i.tmp
	mv $i.tmp $i
done

$HG mv c.new c
$HG mv d.new d

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/revert-unco
