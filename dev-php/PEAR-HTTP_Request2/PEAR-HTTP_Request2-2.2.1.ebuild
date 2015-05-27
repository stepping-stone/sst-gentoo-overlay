# Copyright 1999-2015 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit php-pear-r1

DESCRIPTION="Provides an easy way to perform HTTP requests"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"

DEPEND="dev-lang/php:*[curl,fileinfo,zlib,ssl]
	>=dev-php/PEAR-Net_URL2-2.0.0"
RDEPEND="${DEPEND}"
