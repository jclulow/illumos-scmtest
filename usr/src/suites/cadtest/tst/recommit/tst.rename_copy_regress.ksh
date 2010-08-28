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

cp -r $REPOS/simple-rename $REPOS/squish-rename-copy-regress
cd $REPOS/squish-rename-copy-regress

touch a b			# create the source halves of the rename

#
# NB: hackity hack, sending stderr to stdout here allows us to use the
#   output comparison to trip if the bogus file list isn't what we
#   expect.  Obviously, this relies on *nothing else* going to stdout,
#   unless in situations where we'd otherwise fail...
#
$HG reci -m "Test Squish" > /tmp/reci.$$.out 2>&1
err=$?
grep -iv "\[y/n\]" /tmp/reci.$$.out
rm /tmp/reci.$$.out
(( $err == 0 )) && exit 250 # should fail, because we default to "No"
exit 0
