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

mkdir $REPOS/parent-merge

$HG clone -q $BASEWS $REPOS/parent-merge/parent
cd $REPOS/parent-merge/parent

$HG up -qC 0
echo a >> a
$HG ci -qm "First head"
$HG up -qC 0
echo b >> b
$HG ci -qm "Second head"

$HG clone -q $REPOS/parent-merge/parent $REPOS/parent-merge/child
cd $REPOS/parent-merge/child

HGMERGE=/bin/true $HG merge -q
$HG ci -m "Commit merge"

# Recommit should fail for a parent v. parent merge.
if $HG reci -m "Test"; then 
    exit 255
else
    exit 0
fi
