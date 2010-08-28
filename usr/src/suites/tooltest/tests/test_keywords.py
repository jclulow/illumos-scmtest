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
# Test Mercurial keyword checks
#

import unittest, sys, random
from cStringIO import StringIO
import onbld.Checks.Keywords as Keywords

class TestKeywords(unittest.TestCase):
    def check(self, fh, fname=None, lenient=False):
        out = StringIO()
        Keywords.keywords(fh, filename=fname, lenient=lenient,
                          output=out)
        return out.getvalue()

    def testValid(self):
        "keywords with no SCCS keywords present"
        f = StringIO('')
        self.failIf(self.check(f, fname='test'))

    def testFail(self):
        "keywords with (valid or otherwise) SCCS keywords present"
        keys = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'L', 'M', 'P',
                'Q', 'R', 'S', 'T', 'U', 'W', 'Y', 'Z']
        notkeys = ['J', 'K', 'N', 'O', 'V', 'X']
        
        for i in xrange(1000):
            key = random.randint(0, len(keys) - 1)

            f = StringIO('%%%s%%' % keys[key])
            self.assertEqual(self.check(f, fname='test'),
                             'test: 1: contains SCCS keywords "%%%s%%"\n' %
                             keys[key])

        for i in xrange(1000):
            key = random.randint(0, len(notkeys) - 1)
            f = StringIO('%%%s%%' % notkeys[key])
            self.failIf(self.check(f, fname='test'))
