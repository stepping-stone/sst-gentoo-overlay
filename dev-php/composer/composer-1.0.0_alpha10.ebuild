# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit versionator

MY_PV=$(replace_version_separator _ -)

DESCRIPTION="Dependency Manager for PHP"
HOMEPAGE="https://getcomposer.org/"
SRC_URI="https://getcomposer.org/download/${MY_PV}/composer.phar -> ${P}.phar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/php[json,xml,zip]"

S="${WORKDIR}"

src_unpack() {
	:
}

src_install() {
	newbin "${DISTDIR}/${A}" "${PN}"
}
