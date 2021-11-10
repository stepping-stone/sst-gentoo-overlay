# Copyright 1999-2015 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit php-pear-r2

DESCRIPTION="Manage and handles color data and conversions"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"

DEPEND="dev-lang/php:*[gd]"
RDEPEND="${DEPEND}"
