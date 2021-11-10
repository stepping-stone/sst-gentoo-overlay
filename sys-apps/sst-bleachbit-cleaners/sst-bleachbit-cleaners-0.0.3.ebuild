# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

DESCRIPTION="bleachbit cleaners from/for stepping stone GmbH"
HOMEPAGE="https://github.com/stepping-stone/bleachbit-cleaners"
SRC_URI="https://github.com/stepping-stone/${PN/sst-}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EUPL-1.1"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P/sst-}"

src_install() {
	insinto /usr/share/bleachbit/cleaners
	doins *.xml
	dodoc *.md
}
