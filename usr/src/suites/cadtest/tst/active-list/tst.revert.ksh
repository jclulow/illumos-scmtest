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

$HG -q clone $BASEWS $REPOS/revert
cd $REPOS/revert

# a - modified, reverted
# b - modified, renamed, modification reverted
# c - modified, renamed, both reverted
# d - modified, renamed, rename reverted
# new - created, removed

for i in a b c d; do
	sed -e 's/This/.../' < $i > $i.tmp
	mv $i.tmp $i
done

echo 'new' > new
$HG add new
$HG mv b b.new
$HG mv c c.new
$HG mv d d.new

$HG ci -m "Initial"

for i in a b.new c.new; do
	sed -e 's/\.\.\./This/' < $i > $i.tmp
	mv $i.tmp $i
done

$HG mv c.new c
$HG mv d.new d
$HG rm new

echo "-- Uncommitted"
$HG list
echo "-- Cached"
$HG changed -yi >/dev/null
$HG list
echo "-- Committed"
$HG ci -m "Reverts"
$HG list
