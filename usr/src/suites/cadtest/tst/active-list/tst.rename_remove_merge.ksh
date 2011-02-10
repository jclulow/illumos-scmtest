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
# One branch renames ("you") rename a file
# The other branch ("they") remove it.
# Merge
#

mkdir $REPOS/rename-remove-merge

# They
$HG -q clone $BASEWS $REPOS/rename-remove-merge/parent
cd $REPOS/rename-remove-merge/parent

$HG rm a
$HG ci -qm "(they) Remove"

# You
$HG -q clone -r 0 $REPOS/rename-remove-merge/parent \
    $REPOS/rename-remove-merge/child
cd $REPOS/rename-remove-merge/child

$HG mv a new
$HG ci -qm "(you) Rename"

$HG pull -q
$HG merge -q

echo "-- Uncommitted"
$HG list
echo "-- Cached"
$HG changed -yi >/dev/null
$HG list
echo "-- Committed"
$HG ci -qm "Commit"
$HG list