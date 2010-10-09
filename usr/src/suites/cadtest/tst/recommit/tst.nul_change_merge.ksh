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
# Copyright 2009 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Copyright 2008, 2010, Richard Lowe
#

#
# We create a situation whether there's nothing for us to recommit,
# but some local changes are below the parent tip.
#
# Such that when we do a strip-only reci, the 'safe' rev we go to is
# one that will be bundled and unbundled to keep it safe.
#

mkdir $REPOS/nul-change-merge
$HG clone -q $BASEWS $REPOS/nul-change-merge/parent
cd $REPOS/nul-change-merge/parent

echo d >> d
$HG ci -m "Change"

$HG clone -qr0 $REPOS/nul-change-merge/parent $REPOS/nul-change-merge/child
cd $REPOS/nul-change-merge/child

echo a >> a
$HG ci -m "One"
$HG cat -r0 a > a
$HG ci -m "Two"
$HG pull -q
$HG merge -q
$HG ci -m "Merge"

echo "--- Pre reci"
$HG list
$HG tip --template '{rev}\n{desc}\n' # Should be merge

$HG reci -qm "Test" >/dev/null 2> reci.stderr || \
    (cat reci.stderr > /dev/stderr; exit 253)
echo

# Dump stderr back in, sans strip crud
egrep -v '^sav(ing|ed) (backup )?bundle' reci.stderr > /dev/stderr

echo "--- Post reci"
$HG list 			# Should be blank
$HG tip --template '{rev}\n{desc}\n' # Should be 1 Change
$HG out -q && exit 255		     # Shouldn't be any
exit 0

