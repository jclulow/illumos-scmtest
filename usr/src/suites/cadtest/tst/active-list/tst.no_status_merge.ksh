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

#
# We remove a file in the parent,
# clone a child at a point before that removal
# Modify that same file in the child
# bringover the removal
# merge (which is a conflict child mod v. parent removal), hg will default 'keep'
#
# This will mean the working context is modified (the merge) but contains no files.
# .files() and .status() will be blank
#


mkdir $REPOS/no-status-merge
$HG clone -q $BASEWS $REPOS/no-status-merge/parent
cd $REPOS/no-status-merge/parent
$HG rm c
$HG ci -m "Parent"

$HG clone -qr0 $REPOS/no-status-merge/parent $REPOS/no-status-merge/child
cd $REPOS/no-status-merge/child
echo c >> c
$HG ci -m "Child"
$HG pull -q $REPOS/no-status-merge/parent
$HG merge > /dev/null

echo "--- Uncommitted"
$HG list			# On failure, 'c' will show as modified, not added
echo "--- Committed"
$HG list
