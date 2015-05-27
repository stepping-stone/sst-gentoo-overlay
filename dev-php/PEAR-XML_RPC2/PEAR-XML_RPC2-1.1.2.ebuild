# Copyright 1999-2015 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit php-pear-r1

DESCRIPTION="Generates HTML menus from multidimensional hashes"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"

DEPEND=">=dev-lang/php-5.0.0:*
	>=dev-php/PEAR-HTTP_Request2-2.0.0
	>=dev-php/PEAR-Cache_Lite-1.6.0"
RDEPEND="${DEPEND}"
