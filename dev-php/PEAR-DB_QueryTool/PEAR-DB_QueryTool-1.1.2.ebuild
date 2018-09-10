# Copyright 1999-2015 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit php-pear-r2

DESCRIPTION="An OO-interface for easily retrieving and modifying data in a DB"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"

RPEPEND="dev-php/PEAR-DB
	>=dev-php/PEAR-Log-1.7"
RDEPEND="${DEPEND}"
