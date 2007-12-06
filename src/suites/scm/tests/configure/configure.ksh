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

# Copyright 2007 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#

#
# Create the configuration file based on passed in variables
# or those set in the configuration file provided by run_test
# file.
#

#
# Use the same mechanism as a test suite, use a test purpose
# for the configuration processes.   The first is to do the
# configuration and the second test purpose is to unconfigure
# the test suite.
#
iclist="ic1 ic2"
ic1=config_test_suite
ic2=unconfig_test_suite

#
# NAME
#	createconfig
#
# DESCRIPTION
#	Take the current configuration based on the config file provided
# 	and create the configuration based on variables passed in.
#
createconfig() {
	if [ ! -f $configfile_tmpl ]
	then
		tet_infoline "There is no template config file to create config from."
		configresult="FAIL"
		return
	fi

	if [ -f $configfile ]
	then
		tet_infoline "Test Suite already configured."
		tet_infoline "to unconfigure the test suite use :"
		tet_infoline "   run_test scm unconfigure"
		tet_infoline " or supply an alternate configfile name by using :"
		tet_infoline "   run_test -v configfile=<filename> scm configure"
		configresult="FAIL"
		return
	else
		touch ${configfile}
		if [ $? -ne 0 ]
		then
			tet_infoline "Could not create the configuration file"
			config_result="FAIL"
			return
		fi
	fi

	if [ ! "$online_wait" ]
	then
		online_wait=24
	fi

	exec 3<$configfile_tmpl
	while :
	do
		read -u3 line
		if [[ $? = 1 ]]
		then
			break
		fi
		if [[ "$line" = *([ 	]) || "$line" = *([ 	])#* ]]
		then
			echo $line
			continue
		fi

		variable_name=`echo $line | awk -F= '{print $1}'`
		eval variable_value=\${$variable_name}
		if [[ -z $variable_value ]]
		then
			echo "$line"
		else
			echo $variable_name=$variable_value
		fi
	done > $configfile
}

#
# NAME
#	config_test_suite
#
# DESCRIPTION
#	The test purpose the test suite calls to initialize and
# 	configure the test suite. 
#
config_test_suite() {
	#
	# Check to see if the config file variable is not set,
	# and if not the set to the default value
	#
	if [ -z $configfile ]
	then
		configfile=${TET_SUITE_ROOT}/scm/config/test_config
	fi

	#
	# set the config file template variable to the test_config
	# template file.
	#
	configfile_tmpl=${TET_SUITE_ROOT}/scm/config/test_config.tmpl

	#
	# Call the createconfig function to actually process the variables
	# and process the template and create the configuration file used
	# by the test suite.
	#
	createconfig

	#
	# Verify that the configuration results are PASS or FAIL.
	# Report the results tot he end user.
	#
	if [ "$configresult" = "FAIL" ]
	then
		rm -f $configfile
		tet_infoline "FAIL - Unable to configure test suite."
		tet_result FAIL
	else
		tet_infoline "PASS - Configured test suite."
		tet_result PASS
	fi
}

#
# NAME
#	unconfig_test_suite
#
# DESCRIPTION
#	The test purpose the test suite calls to un-initialize and
# 	configure the test suite. 
#
unconfig_test_suite() {
	#
	# Check to see if the config file variable is not set,
	# and if not the set to the default value
	#
	if [ -z $configfile ]
	then
		configfile=${TET_SUITE_ROOT}/scm/config/test_config
	fi

	#
	# Remove the configuration file provided, and verify the results
	# of the file removal.
	#
	rm -f $configfile
	if [ $? -eq 0 ]
	then
		tet_infoline "PASS - $configfile removed."
		tet_result PASS
	else
		tet_infoline "FAIL - unable to remove $configfile"
		tet_result FAIL
	fi
}

. ${TET_SUITE_ROOT}/scm/include/command_defs.ksh

. ${TET_ROOT}/lib/ksh/tetapi.ksh
. ${TET_ROOT}/lib/ksh/tcm.ksh
