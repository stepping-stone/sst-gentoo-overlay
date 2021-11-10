# Copyright 1999-2015 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit php-pear-r2

DESCRIPTION="Generic tree management, currently supports databases (via DB, MDB and MDB2) and XML as data sources"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="amd64"

DEPEND=">=dev-php/PEAR-DB-1.7.11
	>=dev-php/PEAR-XML_Parser-1.2.8"
RDEPEND="${DEPEND}"
