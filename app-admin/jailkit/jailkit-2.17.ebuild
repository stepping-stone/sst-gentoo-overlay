# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="5"

inherit autotools eutils

DESCRIPTION="Allows you to easily put programs and users in a chrooted environment"
HOMEPAGE="http://olivier.sessink.nl/jailkit/"
SRC_URI="http://olivier.sessink.nl/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-pyc.patch" \
		"${FILESDIR}/${P}-noshells.patch"
}

src_install() {
	default
	doinitd "${FILESDIR}/jailkit"
}
