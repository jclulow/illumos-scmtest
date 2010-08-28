$HG -q clone $BASEWS $REPOS/hgrc-change
cd $REPOS/hgrc-change
echo "[ui]\nusername=Test User" >> $REPOS/hgrc-change/.hg/hgrc

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/hgrc-change
