$HG clone -q $BASEWS $REPOS/mq-unapplied
cd $REPOS/mq-unapplied

$HG qinit
$HG qnew -g a-patch
echo a >> a
$HG qrefresh -g
$HG qnew -g b-patch
echo b >> b
$HG qrefresh -g
$HG qnew -g c-patch
$HG mv c c.new
$HG qrefresh -g
$HG qpop -a

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/mq-unapplied || exit 253

# Yuck
cd $REPOS/mq-unapplied-restore
$HG -R $REPOS/mq-unapplied qapplied > qapplied.pre.$$
$HG -R $REPOS/mq-unapplied-restore qapplied > qapplied.post.$$

cmp qapplied.pre.$$ qapplied.post.$$ || exit 254

$HG -R $REPOS/mq-unapplied qseries > qseries.pre.$$
$HG -R $REPOS/mq-unapplied-restore qseries > qseries.post.$$

cmp qseries.pre.$$ qseries.post.$$ || exit 254

$HG qpush -a			# I wonder...


