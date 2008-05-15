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
# Tests for Checks.Copyright
#

import sys, unittest, time
from cStringIO import StringIO

import onbld.Checks.Copyright as Copyright

class TestCopyright(unittest.TestCase):
	year = time.strftime('%Y')

	def copycheck(self, fh):
		out = StringIO()
		Copyright.copyright(fh, filename='<test>', output=out)
		return out.getvalue()

	def testValid(self):
		'copyright with valid copyright'
		cr = StringIO('Copyright %s Sun Microsystems, Inc.  '
			      'All rights reserved.\n'
			      'Use is subject to license terms.\n' % self.year)

		self.failUnless(not self.copycheck(cr))

	def testReservedMissing(self):
		"copyright with 'All rights reserved' message missing"
		cr = StringIO('Copyright %s Sun Microsystems, Inc.\n'
			      'Use is subject to license terms.\n' % self.year)

		self.assertEqual(self.copycheck(cr),  "<test>: 1: " +
				 "'All rights reserved.' message missing\n")

	def testLicenseTerms(self):
		"copyright without 'Use is subject to license terms' message"

		# Missing
		cr = StringIO(
			'Copyright %s Sun Microsystems, Inc.  '
			'All rights reserved.' % self.year)

		self.assertEqual(self.copycheck(cr), "<test>: 1: " +
				 "'Use is subject to license terms.' "
				 "message missing\n")

		# Misplaced
		cr = StringIO('Copyright %s Sun Microsystems, Inc.  '
			      'All rights reserved.\n'
			      '\n'
			      'Use is subject to license Terms.' % self.year)

		self.assertEqual(self.copycheck(cr), "<test>: 2: "
				 "'Use is subject to license terms.' "
				 "message missing\n")

	def testOldCopyrightFormat(self):
		"copyright with old copyright formats"
		# With (c)
		cr = StringIO('Copyright (c) %s Sun Microsystems, Inc.	'
			      'All rights reserved.\n'
			      'Use is subject to license terms.' % self.year)

		self.assertEqual(self.copycheck(cr), "<test>: 1: "
				 "old copyright with '(c)'\n")

		# with by
		cr = StringIO('Copyright %s by Sun Microsystems, Inc.  '
			      'All rights reserved.\n'
			      'Use is subject to license terms.\n' % self.year)

		self.assertEqual(self.copycheck(cr), "<test>: 1: "
				 "old copyright with 'by'\n")

		# with both
		cr = StringIO('Copyright (c) %s by Sun Microsystems, Inc.  '
			      'All rights reserved.\n'
			      'Use is subject to license terms.\n' % self.year)

		self.assertEqual(self.copycheck(cr), "<test>: 1: "
				 "old copyright with '(c)'\n")

	def testOutOfDateYear(self):
		"copyright with out of date copyright year"
		# Single
		cr = StringIO('Copyright 2001 Sun Microsystems, Inc.  '
			      'All rights reserved.\n'
			      'Use is subject to license terms.\n')

		self.assertEqual(self.copycheck(cr), "<test>: 1: "
				 "wrong copyright year 2001, "
				 "should be %s\n" % self.year)

		# Range
		cr = StringIO('Copyright 1994-2001 Sun Microsystems, Inc.  '
			      'All rights reserved.\n'
			      'Use is subject to license terms.\n')

		self.assertEqual(self.copycheck(cr), '<test>: 1: '
				 'wrong copyright year 1994-2001, '
				 'should be %s\n' % self.year)

		# List
		cr = StringIO('Copyright 1994,2001 Sun Microsystems, Inc.  '
			      'All rights reserved.\n'
			      'Use is subject to license terms.\n')

		self.assertEqual(self.copycheck(cr), '<test>: 1: '
				 'wrong copyright year 1994,2001, '
				 'should be %s\n' % self.year)

		# Both
		cr = StringIO('Copyright 1994,1999-2001 Sun Microsystems, Inc.  '
			      'All rights reserved.\n'
			      'Use is subject to license terms.\n')

		self.assertEqual(self.copycheck(cr), '<test>: 1: '
				 'wrong copyright year 1994,1999-2001, '
				 'should be %s\n' % self.year)

		# List with spaces
		cr = StringIO('Copyright 1994, 2001 Sun Microsystems, Inc.  '
			      'All rights reserved.\n'
			      'Use is subject to license terms.\n')
		self.assertEqual(self.copycheck(cr), '<test>: 1: '
				 'wrong copyright year 1994, 2001, '
				 'should be %s\n' % self.year)

		# Range, then list with spaces
		cr = StringIO('Copyright 1994-1997, 2001 Sun Microsystems, Inc.'
			      '  All rights reserved.\n'
			      'Use is subject to license terms.\n')
		self.assertEqual(self.copycheck(cr), '<test>: 1: '
				 'wrong copyright year 1994-1997, 2001, '
				 'should be %s\n' % self.year)

		# List with spaces, then range
		cr = StringIO('Copyright 1994, 1997-2001 Sun Microsystems, Inc.'
			      '  All rights reserved.\n'
			      'Use is subject to license terms.\n')
		self.assertEqual(self.copycheck(cr), '<test>: 1: '
				 'wrong copyright year 1994, 1997-2001, '
				 'should be %s\n' % self.year)		


	def testDoubleSpacing(self):
		"copyright without double spacing"
		# Single space 
		cr = StringIO('Copyright %s Sun Microsystems, Inc. '
			      'All rights reserved.\n'
			      'Use is subject to license terms.\n' % self.year)

		self.assertEqual(self.copycheck(cr), '<test>: 1: '
				 'need two spaces between copyright and all '
				 'rights reserved phrases\n')

		# Tab
		cr = StringIO('Copyright %s Sun Microsystems, Inc.\t'
			      'All rights reserved.\n'
			      'Use is subject to license terms.\n' % self.year)

		self.assertEqual(self.copycheck(cr), '<test>: 1: '
				 'need two spaces between copyright and all '
				 'rights reserved phrases\n')

if __name__ == '__main__':
	unittest.main()
