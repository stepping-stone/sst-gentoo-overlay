# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay $

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7} )

inherit autotools eutils python-single-r1

DESCRIPTION="Allows you to easily put programs and users in a chrooted environment"
HOMEPAGE="http://olivier.sessink.nl/jailkit/"
SRC_URI="http://olivier.sessink.nl/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${PYTHON_DEPS}"

src_prepare() {
	epatch \
		"${FILESDIR}/${PN}-2.16-ldflags.patch" \
		"${FILESDIR}/${PN}-2.16-python.patch" \
		"${FILESDIR}/${P}-noshells.patch"
	eautoreconf
}

src_install() {
	python_fix_shebang py
	default
	python_optimize "${D}/usr/share/jailkit"
	newinitd "${FILESDIR}/jk_socketd.initd" jk_socketd
}

pkg_postinst() {
	ebegin "Updating /etc/shells"
	{ grep -v "^/usr/sbin/jk_chrootsh$" "${ROOT}"etc/shells; echo "/usr/sbin/jk_chrootsh"; } > "${T}"/shells
	mv -f "${T}"/shells "${ROOT}"etc/shells
	eend $?
}
