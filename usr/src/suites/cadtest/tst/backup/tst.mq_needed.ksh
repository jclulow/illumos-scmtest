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

$HG clone -q $REPOS/basews $REPOS/mq-needed
cd $REPOS/mq-needed

HG="$HG --config extensions.hgext.mq="

$HG backup

# No change, should tell me so
($HG backup -t | grep 'backup is up-to-date') || exit 248

$HG qinit

# Patch queue is new, should backup
($HG backup -t | grep 'backup is up-to-date') && exit 250

$HG qnew -g foo-diff
echo a >> a
$HG qrefresh
$HG qpop

# Patch created, should backup
($HG backup -t | grep 'backup is up-to-date') && exit 252

$HG qdelete foo-diff

# Patch removed, should backup
($HG backup -t grep 'backup is up-to-date') && exit 254

exit 0				# So we don't exit as the grep above did
