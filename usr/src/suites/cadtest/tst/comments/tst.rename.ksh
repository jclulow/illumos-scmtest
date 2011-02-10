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

$HG clone -q $BASEWS $REPOS/rename-comments
cd $REPOS/rename-comments

$HG mv a rename-1
$HG ci -m "Comment 1"
$HG mv rename-1 rename-2
$HG ci -m "Comment 2"
$HG mv rename-2 rename-3
$HG ci -m "Comment 3"
$HG cp rename-3 rename-4
$HG ci -m "Comment 4"

$HG debugcdmal | sed 's/:[0-9a-f]\{1,\}.$//'