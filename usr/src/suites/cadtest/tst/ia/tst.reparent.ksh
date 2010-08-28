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

$HG clone -q $BASEWS $REPOS/reparent-ws
cd $REPOS/reparent-ws

fail() {
	print -u2 "$@"
	exit 255
}

reparent() {
	$HG reparent $1 || fail "Reparent to $1 failed"
	[[ $($HG path default) == $1 ]] || \
	    fail "Parent mismatch $1 v. $($HG path default)"
}

reparent $PWD/cadtest-foo
reparent $BASEWS

rm .hg/hgrc
reparent $PWD/no-hgrc

cp /dev/null .hg/hgrc
reparent $PWD/empty-hgrc

cat <<EOF > .hg/hgrc
[paths]
default = /foo/bar/baz
  continued 
  onto
  more
  lines
EOF
reparent $PWD/continuation-lines

# Make sure the continued bits were removed
(( $(wc -l .hg/hgrc | awk '{print $1}') == 3 )) || exit 254

cat <<EOF >.hg/hgrc
[paths]
default = foo
bar = baz

[other-section]
default = test test

EOF
reparent $PWD/other-default
[[ $(sed -ne 6p .hg/hgrc) == "default = test test" ]] || exit 255
