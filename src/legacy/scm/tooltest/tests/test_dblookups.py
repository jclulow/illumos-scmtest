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
# Copyright 2008 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#

# Copyright 2008, 2010 Richard Lowe

#
# Tests for Checks.DbLookups
#

import unittest
import onbld.Checks.DbLookups as DbLookups


class TestBooBug(unittest.TestCase):
	def setUp(self):
		self.db = DbLookups.BugDB()

	def testNonExistent(self):
		"b.o.o lookup of nonexistent CR"
		b = self.db.lookup("9999999")
		self.assertFalse("9999999" in b )

	def testSynopsis(self):
		"b.o.o synopsis lookup"
		a = self.db.lookup("6442524")
		self.assertEqual(a["6442524"]["synopsis"],
				 '*hostname* hostname(1) should use '
				 'set/gethostname(3c) rather than sysinfo(2)')

	def testProduct(self):
		"b.o.o product lookup"
		a = self.db.lookup("6442524")
		self.assertEqual(a["6442524"]["product"], 'solaris')

	def testCat(self):
		"b.o.o category lookup"
		a = self.db.lookup('6442524')
		self.assertEqual(a["6442524"]["category"], 'utility')

	def testSubCat(self):
		"b.o.o sub-category lookup"
		a = self.db.lookup('6442524')
		self.assertEqual(a["6442524"]["sub_category"], 'configuration')

class TestIllumosBug(unittest.TestCase):
	def setUp(self):
		self.db = DbLookups.BugDB(priority=("illumos",))

	def testNonExistentBug(self):
		"illumos lookup of nonexistent CR"
		b = self.db.lookup("9999999")
		self.assertFalse("9999999" in b)

	def testSynopsis(self):
		"illumos synopsis lookup"
		b = self.db.lookup("2")
		self.assertEqual(b["2"]["synopsis"],
		    "We need a fully open libc (no libc_i18n)")

	def testStatus(self):
		"illumos status lookup"
		b = self.db.lookup("2")
		self.assertEqual(b["2"]["status"], "Resolved")

# Be careful here to *only* reference bugs available via b.o.o or illumos
class TestBugDB(unittest.TestCase):
	def setUp(self):
		self.db = DbLookups.BugDB()

	def testNonExistent(self):
		"bugdb lookup of nonexistent bug"
		b = self.db.lookup('9999999')
		self.failIf(b.has_key('9999999'))

	# XXX: We really need a CR with most of these blank...
	def testBlankBooFields(self):
		"bugdb b.o.o lookup of CR with blank fields"
		boo = DbLookups.BugDB()

		b = boo.lookup('6442524')['6442524']

		self.failUnless(b.has_key('cr_number'))
		self.failUnless(b.has_key('product'))
		self.failUnless(b.has_key('synopsis'))
		self.failUnless(b.has_key('category'))
		self.failUnless(b.has_key('sub_category'))
		self.failUnless(b.has_key('keywords'))
		self.failUnless(b.has_key('status'))
		self.failUnless(b.has_key('date_submitted'))
		self.failUnless(b.has_key('type'))
		self.failUnless(b.has_key('date'))

if __name__ == '__main__':
	unittest.main()
