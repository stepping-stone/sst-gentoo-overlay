# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

case ${ARCH} in
amd64) MY_ARCH=x86_64 ;;
x86)   MY_ARCH=i686 ;;
esac

MY_P="${PN%%-bin}-${PV/_p/r}-linux-generic-${MY_ARCH}"

DESCRIPTION="Convert HTML documents to PDF"
HOMEPAGE="http://www.princexml.com/"
SRC_URI="http://www.princexml.com/download/${MY_P}.tar.gz"

LICENSE="Prince-EULA"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/destdir.patch" || die
}

src_install() {
	DESTDIR="${D}" ./install.sh <<<'/usr'
}
