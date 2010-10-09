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

# Copyright 2008, 2010, Richard Lowe

#
# Make sure we don't allow a rollback that will corrupt the repo
#

$HG clone -q $BASEWS $REPOS/reci-and-rollback
cd $REPOS/reci-and-rollback

#
# We make a non-cylic change, so we know that we clear the undo
# even after we do a real commit (compare to no_change).#

echo a >> a
$HG ci -m "Change"
echo b >> b
$HG ci -m "Revert change"

# Undo data must exist...
[[ -f .hg/store/undo ]] || exit 252

# Excuse the nastyness with stderr...
$HG reci -m "Reci" 2>reci.stderr || (cat reci.stderr > /dev/stderr; exit 253)
egrep -v '^sav(ing|ed) (backup )?bundle' reci.stderr > /dev/stderr

[[ -f .hg/store/undo ]] && exit 253

# Sadly, rollback doesn't return non-0 if it can't be accomplished
# We check for it doing what we want via the stderr comparison.
$HG rollback

$HG verify > /dev/null || exit 255 # Must succeed
