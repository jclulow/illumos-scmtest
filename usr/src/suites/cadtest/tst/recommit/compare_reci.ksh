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

#
# Copyright 2010 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Copyright 2008, 2011, Richard Lowe
#

EXPECTED_OUT=1

function usage {
    	print -u2 "Usage: compare_reci.ksh [-n expected_outgoing] <workspace>"
	exit 2
}

while getopts 'n:' opt; do
    case $opt in
        n) EXPECTED_OUT="$OPTARG";;
        ?) usage;;
    esac
done

shift $(($OPTIND - 1))

if [[ -z "$1" ]]; then
    usage
fi

. $HARNESSDIR/lib/common.ksh

ORIG_REPO=$1
RECI_REPO=${1}-reci

cp -rP $ORIG_REPO $RECI_REPO

cd $RECI_REPO

$HG reci -yqm "Test Squish" > /tmp/reci.$$.out || exit 250
grep -v 'Do you want to backup files first' /tmp/reci.$$.out
rm /tmp/reci.$$.out

OUT=$($HG out -q --template x | wc -c)
if (( $OUT != $EXPECTED_OUT )); then
    echo "Recommit did not leave $EXPECTED_OUT outgoing change(s)"
    exit 1
fi

ws_compare $ORIG_REPO $RECI_REPO
res=$?

[[ $res != 0 ]] && exit $res

# Deal with needing -t in Hg 1.5, but not having it in any lesser version.
HEADS_ARGS="-q"
$HG heads $HEADS_ARGS -t -R $ORIG_REPO > /dev/null 2>&1
[[ $? == 0 ]] && HEADS_ARGS="$HEADS_ARGS -t"

# Deal with needing -t in Hg 1.5, but not having it in any lesser version.
HEADS_ARGS="-q"
$HG heads $HEADS_ARGS -t -R $ORIG_REPO > /dev/null 2>&1
[[ $? == 0 ]] && HEADS_ARGS="$HEADS_ARGS -t"

# Deal with needing -t in Hg 1.5, but not having it in any lesser version.
HEADS_ARGS="-q"
$HG heads $HEADS_ARGS -t -R $ORIG_REPO > /dev/null 2>&1
[[ $? == 0 ]] && HEADS_ARGS="$HEADS_ARGS -t"

# Assume that the reci'd head is the parent of the original repo 
ORIG_HEAD=$($HG parent -q -R $ORIG_REPO )
$HG heads $HEADS_ARGS -R $ORIG_REPO | grep -v $ORIG_HEAD > orig-heads.out.$$

# ... and that the new changeset will be the tip of the reci'd repo
RECI_HEAD=$($HG tip -q -R $RECI_REPO)
$HG heads $HEADS_ARGS -R $RECI_REPO | grep -v $RECI_HEAD > squish-heads.out.$$

cmp orig-heads.out.$$ squish-heads.out.$$ || exit 254

(cd $ORIG_REPO && stat --printf="%n %a %A %F %N\n" *) > orig-fsstat.out.$$
(cd $RECI_REPO && stat --printf="%n %a %A %F %N\n" * | grep -v '\.out\.') > squish-fsstat.out.$$

cmp orig-heads.out.$$ squish-heads.out.$$ || exit 255
