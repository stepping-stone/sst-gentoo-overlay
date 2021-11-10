# Copyright 1999-2015 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit php-pear-r2

DESCRIPTION="Generates HTML menus from multidimensional hashes"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="amd64"

DEPEND=">=dev-php/PEAR-HTTP_Request2-2.0.0
	>=dev-php/PEAR-Cache_Lite-1.6.0"
RDEPEND="${DEPEND}"
