# Copyright 1999-2015 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit php-pear-r1

DESCRIPTION="Dispatch notifications using PHP callbacks"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"

DEPEND=">=dev-lang/php-4.0.0:*"
RDEPEND="${DEPEND}"
