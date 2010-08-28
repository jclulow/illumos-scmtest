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

# Copyright (c) 2007, 2010, Oracle and/or its affiliates. All rights reserved.
# Copyright 2010, Richard Lowe

#
# Tests for Checks.Copyright
#

import sys, unittest, time
from cStringIO import StringIO

import onbld.Checks.Copyright as Copyright

class TestCopyright(unittest.TestCase):
	year = time.strftime('%Y')

	def copycheck(self, string):
                inp = StringIO(string)
		out = StringIO()
		Copyright.copyright(inp, filename='<test>', output=out)
		return out.getvalue()

        def testNone(self):
                self.assertEqual(self.copycheck(''),
                                 '<test>: no copyright message found\n')
                self.failIf(not self.copycheck(''))

        def testOld(self):
                self.assertEqual(self.copycheck('Copyright 2009'),
                                 '<test>: no copyright claim for current year '
                                 'found\n')
                self.failIf(not self.copycheck('Copyright 2009'))

                self.assertEqual(self.copycheck('Copyright 2009\n'
                                                'Copyright 01%s\n'
                                                'Copyright 1998\n' % self.year),
                                 '<test>: no copyright claim for current year '
                                 'found\n')
                self.failIf(not self.copycheck('Copyright 2009\n'
                                           'Copyright 01%s\n'
                                           'Copyright 1998\n'))

        def testValid(self):
                self.failIf(self.copycheck('Copyright 2009\n'
                                           'Copyright (c) 2010'))
                self.failIf(self.copycheck('Copyright 1999,2010'))
                self.failIf(self.copycheck('Copyright 1999-2010'))

if __name__ == '__main__':
	unittest.main()
