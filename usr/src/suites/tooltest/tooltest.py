#! /usr/bin/python
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
# ident	"%Z%%M%	%I%	%E% SMI"
#

#
# Harness for tools tests
#

import unittest, sys, os, glob, fnmatch, imp, getopt

def usage():
	print '''usage: tooltest [-v] [-m moduledir]... [-t testdir] tests...
	-m Specify paths to tools modules
	-t Specify path to tools tests
	-v Verbose'''

def load_test(file):
	dirn, base = os.path.split(file)
	base = base.replace('.py', '')

	modh = imp.find_module(base, [dirn])
	try:
		module = imp.load_module(base, modh[0], modh[1], modh[2])
		return module.__dict__
	finally:
		modh[0].close()

def find_cases(testpath):
	cases = {}

	for fname in glob.glob('%s/test_*.py' % testpath):
		test = load_test(fname)
		cases.update(test)

	for name, test in [(x,v) for x, v in cases.iteritems()
			   if x.startswith('Test')]:
		yield name, unittest.TestLoader().loadTestsFromTestCase(test)

def main(args):
	mpaths = []
	verbose = False
	testpath = None

	progname = args[0]
	del args[0]
    
	try:
		opts, args = getopt.getopt(args, 'vm:t:')
	except getopt.GetoptError:
		usage()
		return 1

	for opt, arg in opts:
		if opt == '-m':
			mpaths.append(arg)
		elif opt == '-t':
			testpath = arg
		elif opt == '-v':
			verbose = True

	#
	# If a testpath isn't specified we default to the 'tests'
	# directory in the same directory as this executable.
	# 
	if not testpath:
		dirn, fn = os.path.split(progname)
		if dirn:
			testpath = os.path.join(dirn, 'tests')
		else:
			testpath = 'tests'

	#
	# If a module path isn't specified we default to
	# /opt/onbld/lib/python
	# 
	if not mpaths:
		sys.path.append('/opt/onbld/lib/python')
	else:
		sys.path.extend(mpaths)

	tests = unittest.TestSuite()
	
	for name, test in find_cases(testpath):
		if args:
			for pat in args:
				if not pat.startswith('Test'):
					pat = 'Test' + pat
				if fnmatch.fnmatch(name, pat):
					tests.addTest(test)
		else:
				tests.addTest(test)

	runner = unittest.TextTestRunner(stream=sys.stdout,
					 verbosity=verbose and 2 or 1)

	try:
		cwd = os.getcwd()
		os.chdir(testpath)
		ret = runner.run(tests)
		os.chdir(cwd)

		return not ret.wasSuccessful()
	except OSError, e:
		print "Test directory does not exist: %s" % e
		return 2

if __name__ == '__main__':
	sys.exit(main(sys.argv))
