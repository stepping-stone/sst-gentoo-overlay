# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit php-pear-r1

DESCRIPTION="Provides an easy way to perform HTTP requests"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"

DEPEND=">=dev-lang/php-5.2.0:*
	dev-lang/php:*[curl,fileinfo,zlib,ssl]
	>=dev-php/PEAR-Net_URL2-2.0.0"
RDEPEND="${DEPEND}"