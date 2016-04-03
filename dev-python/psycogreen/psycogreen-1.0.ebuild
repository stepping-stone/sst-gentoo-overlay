# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="psycopg2 integration with coroutine libraries"
HOMEPAGE="https://bitbucket.org/dvarrazzo/psycogreen https://pypi.python.org/pypi/psycogreen"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="dev-python/psycopg:2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/gevent[${PYTHON_USEDEP}]
		dev-python/eventlet[${PYTHON_USEDEP}]
		)"

RESTRICT="test"
# tests require a running postgresql server

python_test() {
	for t in tests/*.py ; do
		"${PYTHON}" "${t}" || die
	done
}
