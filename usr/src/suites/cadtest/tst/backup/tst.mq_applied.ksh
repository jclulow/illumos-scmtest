$HG clone -q $BASEWS $REPOS/mq-applied
cd $REPOS/mq-applied

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

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/mq-applied || exit 253

# Yuck
cd $REPOS/mq-applied-restore
$HG -R $REPOS/mq-applied qapplied > qapplied.pre.$$
$HG -R $REPOS/mq-applied-restore qapplied > qapplied.post.$$

cmp qapplied.pre.$$ qapplied.post.$$ || exit 254

$HG -R $REPOS/mq-applied qseries > qseries.pre.$$
$HG -R $REPOS/mq-applied-restore qseries > qseries.post.$$

cmp qseries.pre.$$ qseries.post.$$ || exit 254

$HG qpop -a			# I wonder...


