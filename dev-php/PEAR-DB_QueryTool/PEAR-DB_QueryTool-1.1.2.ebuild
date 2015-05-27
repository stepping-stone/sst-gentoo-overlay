# Copyright 1999-2015 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit php-pear-r1

DESCRIPTION="An OO-interface for easily retrieving and modifying data in a DB"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"

RPEPEND=">=dev-lang/php-4.0.0
	dev-php/PEAR-DB
	>=dev-php/PEAR-Log-1.7"
RDEPEND="${DEPEND}"
