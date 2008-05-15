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
# Tests for Checks.DbLookups
#

import unittest

import onbld.Checks.DbLookups as DbLookups
from onbld.Checks import onSWAN


class TestBooBug(unittest.TestCase):
	def testNonExistent(self):
		"b.o.o lookup of nonexistent CR"
		self.assertRaises(DbLookups.NonExistentBug, DbLookups.BooBug,
				  '9999999')

	def testSynopsis(self):
		"b.o.o synopsis lookup"
		b = DbLookups.BooBug('6442524')
		self.assertEqual(b.synopsis(),
				 '*hostname* hostname(1) should use '
				 'set/gethostname(3c) rather than sysinfo(2)')

	def testProduct(self):
		"b.o.o product lookup"
		b = DbLookups.BooBug('6442524')
		self.assertEqual(b.product(), 'solaris')

	def testCat(self):
		"b.o.o category lookup"
		b = DbLookups.BooBug('6442524')
		self.assertEqual(b.cat(), 'utility')

	def testSubCat(self):
		"b.o.o sub-category lookup"
		b = DbLookups.BooBug('6442524')
		self.assertEqual(b.subcat(), 'configuration')

class TestMonaco(unittest.TestCase):
	def setUp(self):
		self.m = DbLookups.Monaco()

	def testNonExistent(self):
		"monaco lookup of nonexistent CR"
		self.failIf(self.m.queryBugs(['9999999']).has_key('9999999'))
		
	def testSynopsis(self):
		"monaco synopsis lookup"
		bug = self.m.queryBugs(['6442524'])['6442524']
		self.assertEqual(bug['synopsis'],
				 '*hostname* hostname(1) should use '
				 'set/gethostname(3c) rather than sysinfo(2)')

	def testCat(self):
		"monaco category lookup"
		bug = self.m.queryBugs(['6442524'])['6442524']
		self.assertEqual(bug['category'], 'utility')

	def testSubCat(self):
		"monaco sub-category lookup"
		bug = self.m.queryBugs(['6442524'])['6442524']
		self.assertEqual(bug['sub_category'], 'configuration')


# Be careful here to *only* reference bugs available via b.o.o
# such that the test works whether monaco or boo is the backend.
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
		boo = DbLookups.BugDB(forceBoo=True)

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

# XXXSWAN:
class TestARC(unittest.TestCase):
	pass

class TestRTI(unittest.TestCase):

	def testValidRTI(self):
		"rti lookup of valid bug"
		self.failUnless(DbLookups.Rti('6455550').accepted())
		
	def testInvalidRTI(self):
		"rti lookup of single, invalid bug"
		self.assertRaises(DbLookups.RtiNotFound, DbLookups.Rti,
				  '124124')
		self.assertRaises(DbLookups.RtiNotFound, DbLookups.Rti,
				  '124124', "/ws/onnv-stc2")

	def testMultipleLines(self):
		"rti lookup returning multiple lines"
		self.assertRaises(DbLookups.RtiInvalidOutput, DbLookups.Rti,
				  '6227559')
		self.assertRaises(DbLookups.RtiInvalidOutput, DbLookups.Rti,
				  '6227559', None, "on")

	def testGoodBadRTI(self):
		"rti lookup of multiple bugs, some invalid"
		self.assertRaises(DbLookups.RtiIncorrectCR, DbLookups.Rti,
				  ['6455550', '124124', 'foo'])

	def testValidRTIGate(self):
		"rti lookup of valid bug with gate specified"
		self.failUnless(DbLookups.Rti('6455550', "onnv-gate").accepted())

	def testValidRTIConsolidation(self):
		"rti lookup of valid bug with consolidation specified"
		self.failUnless(DbLookups.Rti('6455550', None, "on").accepted())

	def testValidRTIWrongGate(self):
		"rti lookup of valid bug in wrong gate"
		self.assertRaises(DbLookups.RtiNotFound, DbLookups.Rti,
				  '6455550', "onnv-stc2")

	def testValidNotAccepted(self):
		"rti lookup of RTI that is not accepted"
		self.failIf(DbLookups.Rti('6227559', "on10-patch").accepted())
		self.failIf(DbLookups.Rti('6227559', "on28-patch").accepted())

	def testValidNonON(self):
		"rti lookup of valid bug in test gate"
		self.failUnless(DbLookups.Rti('6494391', "onnv-stc2").accepted())

if not onSWAN():
	del TestMonaco
	del TestARC
	del TestRTI

if __name__ == '__main__':
	unittest.main()
