#! /usr/bin/python

CDDL = '''
CDDL HEADER START

The contents of this file are subject to the terms of the
Common Development and Distribution License (the "License").
You may not use this file except in compliance with the License.

You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
or http://www.opensolaris.org/os/licensing.
See the License for the specific language governing permissions
and limitations under the License.

When distributing Covered Code, include this CDDL HEADER in each
file and include the License file at usr/src/OPENSOLARIS.LICENSE.
If applicable, add the following below this CDDL HEADER, with the
fields enclosed by brackets "[]" replaced with your own identifying
information: Portions Copyright [yyyy] [name of copyright owner]

CDDL HEADER END
'''

#
# Copyright 2007 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#
# ident	"%Z%%M%	%I%	%E% SMI"
#

#
# Tests for Checks.Cddl
#

import unittest, sys, random, re

from cStringIO import StringIO
import onbld.Checks.Cddl as Cddl

CDDL = CDDL.splitlines()[1:]

class TestCddl(unittest.TestCase):
	def check(self, fh, fname=None, lenient=False):
		out = StringIO()
		Cddl.cddlchk(fh, filename=fname, lenient=lenient,
			     output=out)
		return out.getvalue()

	def testValid(self):
		"cddlchk with valid block"
		f = StringIO('\n'.join(CDDL))
		self.failIf(self.check(f, fname='test'))


	def testMissing(self):
		"cddlchk with missing block"
		f = StringIO('')
		self.assertEqual(self.check(f, fname='test'),
				 'Warning: No CDDL block in file test\n')

	def testLeniency(self):
		"cddlchk leniency with missing block"
		f = StringIO('')
		self.failIf(self.check(f, fname='test', lenient=True))
    
	def testIncomplete(self):
		"cddlchk with incomplete block"
		f = StringIO('\n'.join(CDDL[0:-2]))
		self.assertEqual(self.check(f, fname='test'),
				 'Error: Incomplete CDDL block in file test\n'
				 '    at line 1\n'
				 'Warning: No CDDL block in file test\n')

	def testMultiple(self):
		"cddlchk with multiple blocks"
		f = StringIO('\n'.join(CDDL) + '\n\n' + '\n'.join(CDDL))
		self.assertEqual(self.check(f, fname='test'),
				 'Error: Multiple CDDL blocks in file test\n'
				 '    at lines 1, 20\n')

	# XXX: Must be a better way to copy a list...
	def testOld(self):
		"cddlchk with old block"
		# Old version of CDDL 
		bad = CDDL + []
		bad[3] = 'Common Development and Distribution License, ' + \
			 'Version 1.0 only'
		bad[4] = '(the "License").  You may not use this file ' + \
			 'except in compliance'
		bad.insert(5, 'with the License.')

		f = StringIO('\n'.join(bad))
		self.assertEqual(self.check(f, fname='test'),
			      '''Error: Invalid line in CDDL block in file test
    at line 4, should be
    \'Common Development and Distribution License (the \"License\").\'
    is
    \'Common Development and Distribution License, Version 1.0 only\'\n''')


	def testInvalid(self):
		"cddlchk of invalid blocks"
		for i in xrange(100):
			bad = CDDL + []

			# Skip empty lines
			line = random.randint(1, len(bad) - 2)
			while not bad[line]:
				line = random.randint(1, len(bad) - 2)

			l = list(bad[line])

			#
			# Loop until the shuffled line does not start
			# with a comment character (which would
			# otherwise screw with us)
			#
			random.shuffle(l)
			while l[0] in Cddl.CmntChrs or l == CDDL[line]:
				random.shuffle(l)
	    
			bad[line] = ''.join(l)

			f = StringIO('\n'.join(bad))
			self.assertEqual(self.check(f, fname='test'),
			      '''Error: Invalid line in CDDL block in file test
    at line %d, should be
    \'%s\'
    is
    \'%s\'\n''' % (line + 1, CDDL[line], bad[line]))

if __name__ == '__main__':
	unittest.main()
