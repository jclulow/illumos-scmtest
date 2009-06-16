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
# Copyright 2009 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#

#
# Tests for Checks.Comments
#

import unittest
from cStringIO import StringIO

import onbld.Checks.Comments as Comments

class TestComments(unittest.TestCase):
	def comchk(self, comments, check_db=False):
		out = StringIO()
		Comments.comchk(comments, check_db=check_db,
				output=out)
		return out.getvalue()

	def testBlanks(self):
		'comchk with blank in comments'
		self.assertEquals(self.comchk([' '], False),
				  'WARNING: Blank line(s) in comments\n')

		self.assertEquals(self.comchk([''], False),
				  'WARNING: Blank line(s) in comments\n')

		self.assertEquals(self.comchk(['\t'], False),
				  'WARNING: Blank line(s) in comments\n')

	def testNoSpace(self):
		'comchk with no space between ID and synopsis'
		self.assertEquals(self.comchk(['1111111\tsomething is broken']),
		    'These bugs are missing a single space following the ID:\n'
		    '  1111111\tsomething is broken\n')

                self.assertEquals(self.comchk(['1111111something is broken']),
                     'These bugs are missing a single space following the ID:\n'
                     '  1111111something is broken\n')

	def testInvalidComment(self):
		'comchk with malformed comment'
		self.assertEquals(self.comchk(['Screw Boo']),
			       'These comments are neither bug nor ARC case:\n'
			       '  Screw Boo\n')

	def testIgnored(self):
		"comchk with ignored comments"
		self.failIf(self.comchk(['Contributed by someone',
					       'backout 1111111: Breaks build',
					       'backout 1111112: Eats souls']))

	def testDuplicates(self):
		"comchk with duplicated comments"
		self.assertEquals(self.comchk(['1111111 Something',
					       '1111111 Something'],
					      check_db=False),
			  'These IDs appear more than once in your comments:\n'
			  '  1111111\n')

		self.assertEquals(self.comchk(['PSARC 2006/001 Something',
					       'PSARC 2006/001 Something']),
			  'These IDs appear more than once in your comments:\n'
			  '  PSARC 2006/001\n')

		self.assertEquals(self.comchk(['PSARC/2006/001 Something',
					       'PSARC 2006/001 Something']),
			  'These IDs appear more than once in your comments:\n'
			  '  PSARC 2006/001\n')

		self.assertEquals(self.comchk(['PSARC 2006/001 Something',
					       'PSARC\t2006/001 Something']),
			  'These IDs appear more than once in your comments:\n'
			  '  PSARC 2006/001\n')

	def testNonExistentCR(self):
		"comchk with nonexistent CR in comments"
		self.assertEquals(self.comchk(['9999999 Something broke'],
					      check_db=True),
		      'These bugs/ARC cases were not found in the databases:\n'
		      '  9999999\n')

	def testNonExistentARC(self):
		"comchk with nonexistent ARC case in comments"

		self.assertEquals(self.comchk(['PSARC 2012/001 Something'],
					      check_db=True),
		       'These bugs/ARC cases were not found in the databases:\n'
		       '  PSARC 2012/001\n')

	def testBadBugSynopsis(self):
		"comchk with bad CR synopsis in comments"
		self.assertEquals(self.comchk(['5051903 ypserv goes boom'],
					      check_db=True),
	 "These bugs/ARC case synopsis/names don't match the database entries:\n"
	 "Synopsis/name of 5051903 is wrong:\n"
	 "  should be: 'Ypserv memory leak'\n"
	 "         is: 'ypserv goes boom'\n")

	def testBadARCSynopsis(self):
		"comchk with bad ARC case synopsis in comments"

		self.assertEquals(self.comchk(['PSARC 2006/051 alter ping'],
					      check_db=True),
	 "These bugs/ARC case synopsis/names don't match the database entries:\n"
	 "Synopsis/name of PSARC 2006/051 is wrong:\n"
	 "  should be: 'av1394 interface promotion'\n"
	 "         is: 'alter ping'\n")

	def testValidWithJunk(self):
		"comchk of valid bug/synopsis with junk leading/trailing text"

		self.assertEquals(self.comchk(['5051903 foobar Ypserv memory leak'],
					      check_db=True),
	 "These bugs/ARC case synopsis/names don't match the database entries:\n"
	 "Synopsis/name of 5051903 is wrong:\n"
	 "  should be: 'Ypserv memory leak'\n"
	 "         is: 'foobar Ypserv memory leak'\n")

		self.assertEquals(self.comchk(['5051903 foobarYpserv memory leak'],
					      check_db=True),
	 "These bugs/ARC case synopsis/names don't match the database entries:\n"
	 "Synopsis/name of 5051903 is wrong:\n"
	 "  should be: 'Ypserv memory leak'\n"
	 "         is: 'foobarYpserv memory leak'\n")

		self.assertEquals(self.comchk(['5051903 Ypserv memory leak bar'],
					      check_db=True),
	 "These bugs/ARC case synopsis/names don't match the database entries:\n"
	 "Synopsis/name of 5051903 is wrong:\n"
	 "  should be: 'Ypserv memory leak'\n"
	 "         is: 'Ypserv memory leak bar'\n")

		self.assertEquals(self.comchk(['5051903 Ypserv memory leakbar'],
					      check_db=True),
	 "These bugs/ARC case synopsis/names don't match the database entries:\n"
	 "Synopsis/name of 5051903 is wrong:\n"
	 "  should be: 'Ypserv memory leak'\n"
	 "         is: 'Ypserv memory leakbar'\n")

		self.assertEquals(self.comchk(['6739108 Updated P2 kernel/io-multipath panic: (path_instance == mdi_pi_get_path_instance(vpkt-)vpkt_path)), file: ../../common/io/scsi/adap'],
					      check_db=True),
	 "These bugs/ARC case synopsis/names don't match the database entries:\n"
	 "Synopsis/name of 6739108 is wrong:\n"
	 "  should be: 'panic: (path_instance == mdi_pi_get_path_instance(vpkt-)vpkt_path)), file: ../../common/io/scsi/adap'\n"
	 "         is: 'Updated P2 kernel/io-multipath panic: (path_instance == mdi_pi_get_path_instance(vpkt-)vpkt_path)), file: ../../common/io/scsi/adap'\n")

	def testNewline(self):
		"comchk with newlines"

		self.assertRaises(ValueError, self.comchk, ['foo\nbar'])
		self.assertRaises(ValueError, self.comchk, ['\nfoobar'])
		self.assertRaises(ValueError, self.comchk, ['foobar\n'])

	def testValid(self):
		"comchk with valid comments"
		self.failIf(self.comchk(['5051903 Ypserv memory leak'],
					check_db=True))

		self.failIf(self.comchk(['5051903 Ypserv memory leak (fix lint)'],
					check_db=True))

		coms = ['PSARC 2006/051 av1394 interface promotion',
			'PSARC/2006/484 USB Video Class Driver',
			'PSARC\t2006/384 SATA AHCI HBA driver',
			'WSARC 2007/112 Project Kenai: JBI runtime and clustering support']
		self.failIf(self.comchk(coms, check_db=True))

		self.failIf(self.comchk(['PSARC/2005/679 SATA HBA Framework Support (Updated) (fix unref)'],
								check_db=True))

if __name__ == '__main__':
	unittest.main()
