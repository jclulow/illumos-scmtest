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
# Copyright (c) 2010, Oracle and/or its affiliates. All rights reserved.
#

mkdir $REPOS/phantom-cp

$HG clone -q $BASEWS $REPOS/phantom-cp/parent
$HG clone -q $BASEWS $REPOS/phantom-cp/child

cd $REPOS/phantom-cp/parent
$HG cp a copied
$HG ci -m "Copy"

cd $REPOS/phantom-cp/child
for elt in a b c; do
    echo $elt >> $elt
done
$HG ci -m "Modified"

$HG clone -q $REPOS/phantom-cp/child $REPOS/phantom-cp/merge
cd $REPOS/phantom-cp/merge

$HG pull -q $REPOS/phantom-cp/parent
HGMERGE=internal:other $HG merge -q

echo "-- Uncommitted"
echo " -- Parent"
$HG list -p $REPOS/phantom-cp/parent
echo " -- Child"
$HG list -p $REPOS/phantom-cp/child
echo
$HG commit -m "Commit"
echo "-- Committed"
echo " -- Parent"
$HG list -p $REPOS/phantom-cp/parent
echo " -- Child"
$HG list -p $REPOS/phantom-cp/child
