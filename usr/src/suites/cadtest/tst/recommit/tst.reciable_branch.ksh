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

#
# Recommit with the active list over only the only outgoing head
# should work, regardless of the number of other outgoing heads.
#
# If the active list represents any non-outgoing head, recommit should
# fail.
#
# tst.simple_branch1.ksh confirms that workspaces with multiple
# outgoing heads or branches will still fail.
# 

#
# The simple-branch workspace already contains two branches, revs 1
# and 2.  We must clone it, such that its extant branches are
# non-outgoing
#
$HG clone -q $REPOS/simple-branch $REPOS/reciable-branch
cd $REPOS/reciable-branch

#
# Create a new, 3rd head, the only outgoing head.
#
$HG up -C 0
echo "change me" >> a
$HG ci -qm "Commit"
NEWHEAD=$($HG id -nr tip)

#
# Try to recommit the first non-outgoing head.  Should fail as the
# active list will contain no changesets.
#
$HG up -C 1
$HG reci -ym "Recommit head 1" && exit 253

#
# Try to recommit the second non-outgoing head.  Should also fail.
#
$HG up -C 2
$HG reci -ym "Recommit head 2" && exit 254

#
# Recommit the only outgoing head, this should work.
#
$HG up -C $NEWREV
ksh $HARNESSDIR/tst/recommit/compare_reci.ksh $REPOS/reciable-branch
