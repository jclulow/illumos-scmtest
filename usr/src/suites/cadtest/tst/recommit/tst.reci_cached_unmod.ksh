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

$HG clone -q $BASEWS $REPOS/reci-cached-unmod
cd $REPOS/reci-cached-unmod

echo a >> a
$HG ci -m "Foo" a
$HG changed b                   # Should have no effect, reci must ignore the WC

ksh $HARNESSDIR/tst/recommit/compare_reci.ksh $REPOS/reci-cached-unmod
