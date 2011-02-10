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

# A rename with an intermediate removal, such that the name history forks.
#
# a -> rename -> other-rename -> (removed)
#             \-> newname
#
# We should see a cp a -> newname, and never see rename.

$HG -q clone $BASEWS $REPOS/cp-intermed-rm
cd $REPOS/cp-intermed-rm

$HG cp a rename
$HG ci -m "copy"
$HG cp rename newname
$HG ci -m "Copy"
$HG mv rename other-rename
$HG ci -m "Other rename"
$HG rm other-rename

echo "-- Uncommitted"
$HG list
echo "-- Cached"
$HG changed -yi >/dev/null
$HG list
echo "-- Committed"
$HG ci -m "Committed"
$HG list
