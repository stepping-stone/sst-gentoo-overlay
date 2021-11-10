# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 python3_{5,6,7,8,9} )

inherit distutils-r1

DESCRIPTION="LDAP Data Interchange Format (LDIF) lexer for Pygments"
HOMEPAGE="http://projects.skurfer.com/posts/2011/ldif_pygments/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/pygments"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
