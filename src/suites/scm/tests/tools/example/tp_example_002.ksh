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

#################################################################################
#
# __stc_assertion_start
#
# ID: tp_example_002
#
# DESCRIPTION:
#	example test purpose
#
# STRATEGY:
#	1. Output assertion message
#	2. Output report message
#	3. Output pass message
#
# TESTABILITY: explicit
#
# TEST_AUTOMATION_LEVEL: automated
#
# CODING_STATUS: COMPLETED (2007-12-06)
#
# __stc_assertion_end
#
################################################################################

tp_example_002()
{
	cti_assert ASSERT_002 "tp_example_002 test purpose"
	cti_report "testing 1, 2, 3"
	cti_pass "tp_example_002 passed"   
}
