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
# Tests for Checks.HdrChk
#

import unittest, sys
from cStringIO import StringIO

import onbld.Checks.HdrChk as HdrChk

class TestHdrChk(unittest.TestCase):
	def hdrchk(self, fh, name=None, lenient=False):
		out = StringIO()
		HdrChk.hdrchk(fh, filename=name, lenient=lenient,
			      output=out)
		return out.getvalue()

	def testValid(self):
		"hdrchk of valid header"
		f = open('hdrchk/valid.h')
		self.failIf(self.hdrchk(f))
		f.close()
    
	def testCopyright(self):
		"hdrchk with missing copyright"
		f = open('hdrchk/nocopyright.h')
		self.assertEquals(self.hdrchk(f),
				  'hdrchk/nocopyright.h: line 22: '
				  'Missing copyright in opening comment\n')
		f.close()
	
	def testHeaderGuard(self):
		"hdrchk with missing header guards"
		f = open('hdrchk/noguards.h')
		self.assertEquals(self.hdrchk(f),
				  'hdrchk/noguards.h: line 27: '
				  'Invalid or missing header guard\n'
				  'hdrchk/noguards.h: '
				  'Missing or invalid ending header guard\n')
		f.close()

	def testEndGuard(self):
		"hdrchk with invalid ending header guard"
		f = open('hdrchk/endguard.h')
		contents = f.read()
		f.close()

		# No end guard at all
		self.assertEquals(self.hdrchk(StringIO(contents),
					      name='hdrchk/endguard.h'),
				  'hdrchk/endguard.h: '
				  'Missing or invalid ending header guard\n')


		# Bad end guard comment
		badcomment = contents + '#endif /* _INCORRECT_H */\n'
		self.assertEquals(self.hdrchk(StringIO(badcomment),
					      name='hdrchk/endguard.h'),
				  'hdrchk/endguard.h: '
				  'Missing or invalid ending header guard\n')

		# No endguard comment
		nocomment = contents + '#endif\n'
		self.assertEquals(self.hdrchk(StringIO(nocomment),
					      name='hdrchk/endguard.h'),
				  'hdrchk/endguard.h: '
				  'Missing or invalid ending header guard\n')


	def testKeywords(self):
		"hdrchk with missing #pragma ident"
		# Header with no keywords, but no #pragma ident, is valid
		f = open('hdrchk/keywords.h')
		self.failIf(self.hdrchk(f))
		f.close()

	def testWrongKeywords(self):
		"hdrchk with present but incorrect #pragma ident"
		f = open('hdrchk/wrongkeywords.h')
		self.assertEquals(self.hdrchk(f), 'hdrchk/wrongkeywords.h: '
				  'line 34: Invalid #pragma ident\n')
		f.close()

	def testInclude(self):
		"hdrchk with relative #include"
		f = open('hdrchk/badinclude.h')
		self.assertEquals(self.hdrchk(f), 'hdrchk/badinclude.h: '
				  'line 40: Bad include\n')
		f.close()

	def testNoCppGuards(self):
		"hdrchk with missing __cplusplus guards"
		f = open('hdrchk/nocppguards.h')
		self.assertEquals(self.hdrchk(f), 'hdrchk/nocppguards.h: '
				  'Missing __cplusplus guard\n')
		f.close()

	def testNoCppEndGuard(self):
		"hdrchk with missing __cplusplus end guard"
		f = open('hdrchk/noendcppguard.h')
		self.assertEquals(self.hdrchk(f), 'hdrchk/noendcppguard.h: '
				  'Missing closing #ifdef __cplusplus\n')
		f.close()

	def testBadCppGuards(self):
		"hdrchk with malformed __cplusplus guards"
		# Malformed guards
		f = open('hdrchk/malformedcppguards.h')
		self.assertEquals(self.hdrchk(f),
				  'hdrchk/malformedcppguards.h: line 39: '
				  'Bad __cplusplus clause\n'
				  'hdrchk/malformedcppguards.h: line 63: '
				  'Bad __cplusplus clause\n')
		f.close()

	def testNoCppGuardNeeded(self):
		"hdrchk of file not needing __cplusplus guards"
		f = open('hdrchk/dontcppguard.h')
		self.failIf(self.hdrchk(f))
		f.close()
	
	def testLenientCppGuards(self):
		"hdrchk leniency with missing __cplusplus guards"
		f = open('hdrchk/nocppguards.h')
		self.failIf(self.hdrchk(f, lenient=True))
		f.close()

	def testLenientIdent(self):
		"hdrchk leniency with ident before header guard"
		f = open('hdrchk/keywordsbeforeguard.h')
		self.failIf(self.hdrchk(f, lenient=True))
		f.close()

	def testLenientGuards(self):
		"hdrchk leniency with bad header guard names"
		#
		# We purturb the filename of valid.h to make the
		# our view of the header guards innacurate.
		#
		f = open('hdrchk/valid.h')
		self.failIf(self.hdrchk(f, name='bogon.h', lenient=True))
		f.close()

	def testLenientInclude(self):
		"hdrchk leniency with relative #include"
		f = open('hdrchk/badinclude.h')
		self.failIf(self.hdrchk(f, lenient=True))
		f.close()
	
	
if __name__ == '__main__':
	unittest.main() 
