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

HARNESSDIR=$(cd $(dirname $0) && pwd)
DTEST=${HARNESSDIR}/dtest.pl

while getopts h:kt: opt; do
    case $opt in
	h) HG=$OPTARG;;
	t) RESULTDIR=$OPTARG;;
	k) KEEPREPOS=1;;
	?)
	    print -u2 "Usage: cadtest [-h <hg executable>] -t <test result name>"
	    exit 2
	    ;;
    esac
done

shift $(($OPTIND - 1))

if [[ -z "$RESULTDIR" ]]; then
	print -u2 "You must specify a test result name, with -t"
	exit 2
fi

HG=${HG:-hg}

if [[ ! -x $(which $HG) ]]; then
	print -u2 "Could not find Hg executable '$HG'"
	exit 2
fi

BASEDIR=$HARNESSDIR/results/$RESULTDIR
export BACKUPDIR=$BASEDIR/cdm.backup.$$/
export HG="$HG --config cdm.backupdir=$BACKUPDIR"

mkdir -p $BASEDIR

export REPOS=$BASEDIR/repos.$$
export BASEWS=$REPOS/basews
export EMPTYWS=$REPOS/emptyws
export HARNESSDIR
mkdir -p $REPOS

echo "Mercurial version:"
$HG version | head -1
echo

print "Creating baseline...\c "
mkdir $BASEWS
cd $BASEWS
$HG init
for elt in a b c d e f g h; do
    echo "This is file $elt" >> $elt
    $HG add $elt
done
$HG ci -m "Baseline"
cd $BASEDIR
$HG init $EMPTYWS
print "done"

if [[ -z $1 ]]; then
	TESTS=$HARNESSDIR/tst
else
	TESTS="$@"
fi


if ! /usr/perl5/bin/perl $DTEST $TESTS; then
	echo "Tests failed"
	FAILED=1    
fi

if [[ -n "$KEEPREPOS" || -n "$FAILED" ]]; then
	echo "Workspaces are in $REPOS"
	echo "Backups are in $BACKUPDIR"
else
	    rm -rf $REPOS $BACKUPDIR
fi

