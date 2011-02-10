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

# Copyright 2010, Richard Lowe

#
# An edge case of file rename/copy is that it is possible to rename
# the same file twice in the same changeset by copying the file twice,
# and then deleting the original (renames are just copy/delete, in
# general).  This can trip recommit as the source file name has now
# been implicitly removed twice (as the source name of both renames),
# and only one removal may be attempted by the recommit itself.
#
# See: 6927290 cdm recommit can fail if a file is removed more than once.
#

$HG -q clone $BASEWS $REPOS/rename-twice
cd $REPOS/rename-twice

$HG cp a name1
$HG cp a name2
$HG rm a
$HG ci -m "Commit"

ksh $HARNESSDIR/tst/recommit/compare_reci.ksh $REPOS/rename-twice
