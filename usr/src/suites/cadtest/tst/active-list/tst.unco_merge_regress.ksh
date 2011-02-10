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
# Make sure that the AL sees both sides of an uncommitted merge
#

$HG clone -q $BASEWS $REPOS/unco_merge_regress
cd $REPOS/unco_merge_regress

$HG mv a new-a
$HG ci -qm "One"

$HG cp b new-b
$HG ci -qm "Two"

$HG rm c
$HG ci -qm "Three"

touch new-1
$HG add new-1
$HG ci -qm "Four"


$HG up -qC 0


$HG mv d new-d
$HG ci -qm "Five"

$HG cp e new-e
$HG ci -qm "Six"

$HG rm f
$HG ci -qm "Seven"

touch new-2
$HG add new-2
$HG ci -qm "Eight"

$HG up -qC 4

$HG merge -q

echo "-- Uncommitted"
$HG list
echo "-- Cached"
$HG changed -i > /dev/null
$HG list 
