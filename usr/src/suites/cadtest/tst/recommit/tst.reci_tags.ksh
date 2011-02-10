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
# Copyright 2008, 2011, Richard Lowe
#

cp -r $REPOS/simple-mod $REPOS/squish-tags
cd $REPOS/squish-tags

echo a >> a
$HG ci -m "Random change"


# Tags that should remain
$HG tag -r0 repokeep
$HG tag -r0 'repo with spaces keep'
$HG tag -lr0 localkeep
$HG tag -lr0 'local with spaces keep'

# Tags that should be removed
$HG tag -r tip repoflush
$HG tag -r tip 'repo with spaces flush'
$HG tag -lr tip 'local with spaces flush'
$HG tag -lr tip localflush

# Multiply defined tags (earlier definition, should remain)  
$HG tag -r0 repooverkeep
$HG tag -r0 'repo over space keep'
$HG tag -lr0 localoverkeep
$HG tag -lr0 'local over space keep'

# Multiply defined tags (later definition, should be removed)
$HG tag -fr tip repooverkeep
$HG tag -fr tip 'repo over space keep'
$HG tag -flr tip localoverkeep
$HG tag -flr tip 'local over space keep'

$HG reci -yqm "Test squish" > squish.out.$$ || exit 254

# Nodes vary
sed -e 's/\([0-9]\{1,\}\):[^:]\{1,\}/\1/' squish.out.$$ | \
    grep -v 'Do you want to backup files first'
echo
echo "Erroneously remaining tags:"
# Make sure the tags are really gone
grep -v 'keep$' .hgtags .hg/localtags && exit 1

echo
echo "Remaining tags:"
# Make sure tags that should remain, do
$HG tags | sed -e 's/:.*$//'
