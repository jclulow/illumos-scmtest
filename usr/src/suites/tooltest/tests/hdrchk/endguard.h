/*
 * CDDL HEADER START
 *
 * The contents of this file are subject to the terms of the
 * Common Development and Distribution License (the "License").
 * You may not use this file except in compliance with the License.
 *
 * You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
 * or http://www.opensolaris.org/os/licensing.
 * See the License for the specific language governing permissions
 * and limitations under the License.
 *
 * When distributing Covered Code, include this CDDL HEADER in each
 * file and include the License file at usr/src/OPENSOLARIS.LICENSE.
 * If applicable, add the following below this CDDL HEADER, with the
 * fields enclosed by brackets "[]" replaced with your own identifying
 * information: Portions Copyright [yyyy] [name of copyright owner]
 *
 * CDDL HEADER END
 */

/*
 * Copyright 2007 Sun Microsystems, Inc.  All rights reserved.
 * Use is subject to license terms.
 */

#ifndef _ENDGUARD_H
#define	_ENDGUARD_H

#pragma ident	"%Z%%M%	%I%	%E% SMI"

/*
 * Is missing an ending header guard.
 */

#ifdef __cplusplus
extern "C" {
#endif

#include <includes.h>

#define	MACROS values

struct tag {
	type_t member;
};

typedef predefined_types new_types;

type_t global_variables;

void functions(void);

#ifdef __cplusplus
}
#endif
