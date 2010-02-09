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

if [[ -z "$1" ]]; then
	print -u2 "Usage: compare_reci.ksh <workspace>"
	exit 2
fi

ORIG_REPO=$1
RECI_REPO=${1}-reci

cp -rP $ORIG_REPO $RECI_REPO 
cd $RECI_REPO

$HG reci -fm "Test Squish" > /tmp/reci.$$.out || exit 250
grep -v 'Do you want to backup files first' /tmp/reci.$$.out
rm /tmp/reci.$$.out

gdiff -rux .hg $ORIG_REPO $RECI_REPO || exit 251

$HG -R $ORIG_REPO list > orig.out.$$
$HG -R $RECI_REPO list > squish.out.$$

$HG branch -R $ORIG_REPO > orig-branch.out.$$
$HG branch -R $RECI_REPO > squish-branch.out.$$

# Assume that the reci'd head is the parent of the original repo 
ORIG_HEAD=$($HG parent -q -R $ORIG_REPO )
$HG heads -q -R $ORIG_REPO | grep -v $ORIG_HEAD > orig-heads.out.$$

# ... and that the new changeset will be the tip of the reci'd repo
RECI_HEAD=$($HG tip -q -R $RECI_REPO)
$HG heads -q -R $RECI_REPO | grep -v $RECI_HEAD > squish-heads.out.$$

cmp orig.out.$$ squish.out.$$ || exit 252
cmp orig-branch.out.$$ squish-branch.out.$$ || exit 253
cmp orig-heads.out.$$ squish-heads.out.$$ || exit 254

(cd $ORIG_REPO && stat --printf="%n %a %A %F %N\n" *) > orig-fsstat.out.$$
(cd $RECI_REPO && stat --printf="%n %a %A %F %N\n" * | grep -v '\.out\.') > squish-fsstat.out.$$

cmp orig-fsstat.out.$$ squish-fsstat.out.$$ || exit 255
