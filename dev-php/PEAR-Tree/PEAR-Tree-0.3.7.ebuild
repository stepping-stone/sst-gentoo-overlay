# Copyright 1999-2015 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit php-pear-r1

DESCRIPTION="Generic tree management, currently supports databases (via DB, MDB and MDB2) and XML as data sources"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"

DEPEND=">=dev-lang/php-4.3.0:*
	>=dev-php/PEAR-DB-1.7.11
	>=dev-php/PEAR-XML_Parser-1.2.8"
RDEPEND="${DEPEND}"
