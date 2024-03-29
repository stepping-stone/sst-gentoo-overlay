# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

PYTHON_COMPAT=( python2_7 )
inherit eutils distutils-r1 multilib

DESCRIPTION="MySQL Utilities provides a collection of command-line utilities that are used for maintaining and administering MySQL servers"
HOMEPAGE="http://dev.mysql.com/doc/mysql-utilities/1.5/en/"
SRC_URI="mirror://mysql/Downloads/MySQLGUITools/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="dev-python/mysql-connector-python[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

src_prepare() {
	# conflicts with dev-python/mysql-connector-python
	rm -r "${S}/mysql/connector" || die
}

python_install() {
	distutils-r1_python_install
	# Remove another collision
	rm "${D}usr/$(get_libdir)/${EPYTHON}/site-packages/mysql/__init__.py" || die
}
