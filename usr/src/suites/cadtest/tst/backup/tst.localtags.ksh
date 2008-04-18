$HG -q clone $BASEWS $REPOS/localtags

cd $REPOS/localtags

hg tag -l localtag

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/localtags
