#! /usr/bin/ksh
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#

# Copyright 2008, 2011, Richard Lowe

#
# Compare the clear backup tarball with the workspace
# Usage: clear_compare <workspace> <workspace backupname>
#
# Compares file contents for regular files, symlink destination path
# for symlinks.
#

clear_compare() {
    typeset repo=$1
    typeset backupname=$2
    typeset tarfile="$BACKUPDIR/${backupname}/latest/clear.tar.gz"
    typeset old_pwd="$PWD"
    
    cd $repo                    # Must be in the original repo

    ret=0
    gtar tvf $tarfile | while read perms junk junk junk junk file junk dest; do
        typeset head=${file%%/*} # Head node
        typeset path=${file#*/}  # File pathname

        case $head in
            working) filecmd="cat";;                  # Working copy
            +([0-9a-f])) filecmd="$HG cat -r $head";; # Committed
            *)                                        # Junk
                print "Garbage head in clear tar: $head" 
                ret=1;;
        esac

        printf "Rev: '%s'\tFile: '%s'\n" $head $path
        #
        # With symlinks, we need to compare the destination path.
        #
        if [[ $perms == l* ]]; then
            typeset tardest=${dest}
            typeset filedest=""

            case $head in
                working) filedest=$(readlink $path);;
                *) filedest=$($HG cat -r $head $path);;
            esac

            if [[ $tardest != $filedest ]]; then
                printf "Symlink mismatch: tar: %s v. file: %s\n" \
                    $tardest $filedest
                ret=1
            fi
        else
            gdiff -u --label "tar" --label "workspace" \
                <(gtar Oxf $tarfile $file) <($filecmd $path)
            ret=$(($ret|$?))
        fi

        echo
        echo "---------------------------------------"
        echo
    done

    cd $old_pwd
            
    return $ret
}


if [[ -z "$1" ]]; then
	print -u2 "Usage: compare_bu_restore.ksh <workspace>"
	exit 2
fi

ORIG_REPO=$1
BACKUP_NAME=$(basename $1)
RESTORE_REPO=${1}-restore

. $HARNESSDIR/lib/common.ksh

cd $ORIG_REPO
ORIG_PARENT=$($HG path default) 

$HG backup || exit 255

$HG -q clone $ORIG_PARENT $RESTORE_REPO
cd $RESTORE_REPO

$HG restore $BACKUP_NAME || exit 255 

# Compare original workspace with restored workspace
ws_compare $ORIG_REPO $RESTORE_REPO || echo "Workspaces differ"
ret=$?

# Compare clear backups against workspace
clear_compare $ORIG_REPO $BACKUP_NAME || echo "Backed up clear files differ"
ret=$(($? || $ret))

exit $ret
