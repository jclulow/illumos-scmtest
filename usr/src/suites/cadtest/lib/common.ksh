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
# ws_compare <tag> <reference_ws> <new_ws>
#
# Compare reference_ws to new_ws, using tag to uniquify output data
#
# Compares workspace contents (diff), AL, branch, hgrc, local tags,
# status, and stat(2) of workspace contents.
#

ws_compare() {
	typeset oldws=$1
	typeset newws=$2
        typeset ret=0

	gdiff -rux .hg $oldws $newws || echo "Workspace contents differ"
        ret=$(($ret || $?))

	cmp <($HG -R $oldws list) <($HG -R $newws list) || \
	    echo "Active lists differ"
        ret=$(($ret || $?))

	cmp <($HG branch -R $oldws) <($HG branch -R $newws) || \
	    echo "Current branches differ"
        ret=$(($ret || $?))

	cmp $oldws/.hg/hgrc $newws/.hg/hgrc || echo "hgrc files differ"
        ret=$(($ret || $?))

	if [[ -f $oldws/.hg/localtags ]]; then
	    cmp $oldws/.hg/localtags $newws/.hg/localtags || \
		echo "Local tag lists differ"
            ret=$(($ret || $?))
	fi

        if [[ -d $oldws/.hg/cdm ]]; then
            gdiff -ru $oldws/.hg/cdm $newws/.hg/cdm || \
                echo "Cdm metadata differs"
            ret=$(($ret || $?))
        fi

	cmp <($HG -R $oldws status -C) <($HG -R $newws status -C) || \
	    echo "Working copy statuses differ"
        ret=$(($ret || $?))

	cmp <(cd $oldws && stat --printf="%n %a %A %F %N\n" *) \
	    <(cd $newws && stat --printf="%n %a %A %F %N\n" *) || \
	    echo "File metadata differs"
        ret=$(($ret || $?))

        return $ret
}
