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
# Copyright 2008, 2011 Richard Lowe
#

# Make sure we fail if the branch name isn't 'default'

$HG clone -q $BASEWS $REPOS/branchchk-name
cd $REPOS/branchchk-name

$HG branch -q look-at-me-im-special
echo a >> a
$HG ci -qm "Change branch name"  2>&1 >/dev/null

$HG branchchk && exit 254 	# Should fail, wrong branch name

echo
$HG branch -qf default		# Fix the branch
$HG ci -m "Reset branch" 2>&1 >/dev/null
# Reci to make the created branch truly go away
$HG reci -yqm "Reset" | grep -v '^Do you want to backup files first?'

$HG branchchk || exit 255	# Should succeed this time.
