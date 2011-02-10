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

$HG clone -q $BASEWS $REPOS/metadata-backup
cd $REPOS/metadata-backup

mkdir .hg/cdm
mkdir -p.hg/cdm/with/sub/dirs

for path in foo.NOT with/sub/dirs/bar some-random-file; do
    echo $path >> .hg/cdm/${path}
done

ksh $HARNESSDIR/tst/backup/compare_bu_restore.ksh $REPOS/metadata-backup
