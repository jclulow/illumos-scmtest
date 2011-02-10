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

cd $REPOS
$HG -q clone $BASEWS simple-branch
cd simple-branch

echo "foo" >> a
$HG ci -qm "Head 1"

$HG up -qC 0 > /dev/null
echo "bar" >> b

echo "--- Second Branch"

echo "-- Uncommitted"
$HG list
echo "-- Cached"
$HG changed -yi >/dev/null
$HG list
echo "-- Committed"
$HG ci -qm "Head 2"
$HG list

echo "-- Comments"
$HG comments

echo "--- Other Branch"
$HG up -qC 1 > /dev/null

echo "-- Committed"
$HG list

echo "-- Comments"
$HG comments

echo "--- No Branch"
$HG up -qC 0 > /dev/null

echo "-- Committed"
$HG list

echo "-- Comments"
$HG comments
