# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit php-pear-r1

DESCRIPTION="An implementation of Integrated Templates API with template 'compilation' added"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"

DEPEND=">=dev-lang/php-4.3.0:*[ctype]"
RDEPEND="${DEPEND}"