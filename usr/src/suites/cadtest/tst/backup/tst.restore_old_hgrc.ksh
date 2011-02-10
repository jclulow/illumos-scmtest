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

# Hand-roll an old-style metadata backup and restore it.

$HG clone -q $BASEWS $REPOS/restore-old-hgrc
cd $REPOS/restore-old-hgrc

echo a > a
hg ci -m "change"
echo <<EOF >> .hg/hgrc
[ui]
user=foo
EOF

$HG bu

# Copy the hgrc in (as used to be the case), remove the metadata tarball.
cp .hg/hgrc $BACKUPDIR/restore-old-hgrc/latest
rm $BACKUPDIR/restore-old-hgrc/latest/metadata.tar.gz

$HG clone -q $BASEWS $REPOS/restore-old-hgrc-restore
cd $REPOS/restore-old-hgrc-restore

$HG restore restore-old-hgrc

cmp $REPOS/restore-old-hgrc/.hg/hgrc \
   $REPOS/restore-old-hgrc-restore/.hg/hgrc || exit 255
