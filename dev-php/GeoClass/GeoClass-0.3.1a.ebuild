# Copyright 1999-2015 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="GeoClass provides classes to handle georeferenced data"
HOMEPAGE="http://www.multimediamotz.de/GeoClass/"
SRC_URI="mirror://sourceforge/geoclassphp/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64"

DEPEND="dev-lang/php:*"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Volumes/MMMFIRE/multimediamotz/${PN}/${P}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-constructor.patch"
}

src_install() {
	rm LICENSE
	insinto /usr/share/php/Geo
	doins -r .
}
