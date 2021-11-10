# Copyright 1999-2015 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit php-pear-r2

DESCRIPTION="Generates HTML menus from multidimensional hashes"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="amd64"

DEPEND="dev-php/PEAR-HTML_Template_Sigma"
RDEPEND="${DEPEND}"
