#! /usr/bin/ksh -p
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
# Copyright 2007 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#

#
# The main test case file for the create subfunction of the iscsitadm command.
# This file contains the test startup functions and the invocable component list
# of all the test purposes that are to be executed.
#

#
# Set the tet global variables tet_startup and tet_cleanup to the
# startup and cleanup function names
#
tet_startup="startup"
tet_cleanup="cleanup"

#
# The list of invocable components for this test case set.
# All the components are a 1:1 relation to each test purpose.
#
iclist="ic1 ic2"
ic1="tp_example_001"
ic2="tp_example_002"

#
# Source in each of the test purpose files that are associated with
# each of the invocable components listed in the previous settings.
#
. ./tp_example_001
. ./tp_example_002

#
# The startup function that will be called when this test case is
# invoked before any test purposes are executed.
#
startup()
{
	cti_report "startup"
}

#
# The cleanup function that will be called when this test case is
# invoked after all the test purposes are executed (or aborted).
#
cleanup()
{
	cti_report "cleanup"
}


#
# Source in the common utilities and tools that are used by the test purposes
# and test case.
#


#
# Source in the cti and tet required utilities and tools.
#

. ${TET_ROOT:?}/common/lib/ctilib.ksh
