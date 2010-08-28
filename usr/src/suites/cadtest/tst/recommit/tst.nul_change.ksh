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

#
# Create a set of changes that don't change anything, then recommit them.
#

$HG clone -q $BASEWS $REPOS/nul-change
cd $REPOS/nul-change

# Make changes

echo "a" > a
$HG ci -m "Change a"
$HG mv b new_b
$HG ci -m "Rename b"
$HG rm c
$HG ci -m "Remove c"
touch new-file
$HG add new-file
$HG ci -m "Add new-file"

# Unmake changes
$HG cat -r0 a > a
$HG ci -m "Unchange a"
$HG mv new_b b
$HG ci -m "Unrename b"
$HG cat -r0 c > c
$HG add c
$HG ci -m "Unremove c"
$HG rm new-file
$HG ci -m "Unadd new-file"

echo "--- Pre reci"
$HG list			     # Should be blank
$HG tip --template '{rev}\n{desc}\n'  # Should be Unadd new-file
echo
$HG reci -m "Recommit" >/dev/null || exit 254
echo "--- Post reci"
$HG list			     # Should still be blank
$HG tip --template '{rev}\n{desc}\n' # Should be rev 0
$HG out -q && exit 255		     # Shouldn't be any
exit 0
