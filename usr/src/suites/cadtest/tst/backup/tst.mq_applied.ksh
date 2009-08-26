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
# Copyright 2009 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#

$HG clone -q $BASEWS $REPOS/mq-applied
cd $REPOS/mq-applied

HG="$HG --config extensions.hgext.mq="

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


