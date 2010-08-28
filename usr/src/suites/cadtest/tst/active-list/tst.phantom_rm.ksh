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
# Copyright (c) 2008, 2010, Oracle and/or its affiliates. All rights reserved.
#

mkdir $REPOS/phantom-rm

$HG clone -q $BASEWS $REPOS/phantom-rm/parent
$HG clone -q $BASEWS $REPOS/phantom-rm/child

cd $REPOS/phantom-rm/parent
$HG mv a renamed
$HG ci -m "Rename"

cd $REPOS/phantom-rm/child
for i in c d e f; do
	echo $i >> $i
done
$HG ci -m "Modified"

$HG clone -q $REPOS/phantom-rm/child $REPOS/phantom-rm/merge
cd $REPOS/phantom-rm/merge

$HG pull -q $REPOS/phantom-rm/parent
$HG merge -q

echo "-- Uncommitted"
echo " -- Parent"
$HG list -p $REPOS/phantom-rm/parent
echo " -- Child"
$HG list -p $REPOS/phantom-rm/child
echo
$HG commit -m "Commit"
echo "-- Committed"
echo " -- Parent"
$HG list -p $REPOS/phantom-rm/parent
echo " -- Child"
$HG list -p $REPOS/phantom-rm/child
