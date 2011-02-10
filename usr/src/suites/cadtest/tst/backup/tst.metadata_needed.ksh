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

# Copyright 2009, 2011, Richard Lowe

$HG clone -q $REPOS/basews $REPOS/metadata-needed
cd $REPOS/metadata-needed

mkdir -p .hg/cdm

$HG backup

# No change, should tell me so
($HG backup -t | grep 'backup is up-to-date') || exit 248

touch .hg/cdm/foo.NOT

# Needs a backup new file
($HG backup -t | grep 'backup is up-to-date') && exit 249

echo foo > .hg/cdm/foo.NOT

# Needs a backup file changed
($HG backup -t | grep 'backup is up-to-date') && exit 249

rm .hg/cdm/foo.NOT

# Needs a backup file removed
($HG backup -t | grep 'backup is up-to-date') && exit 249

mkdir -p .hg/cdm/some/subdir
# Needs a backup,  new subdir
($HG backup -t | grep 'backup is up-to-date') && exit 249

touch .hg/cdm/some/subdir/foo
# Needs a backup, new file in subdir
($HG backup -t | grep 'backup is up-to-date') && exit 249

exit 0
