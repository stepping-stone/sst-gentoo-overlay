# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"
PYTHON_COMPAT=( python{2_6,2_7,3_3} )

inherit distutils-r1

DESCRIPTION="Python library for working with the PuppetDB REST API."
HOMEPAGE="https://pypi.python.org/pypi/pypuppetdb"
SRC_URI="https://pypi.python.org/packages/source/p/pypuppetdb/pypuppetdb-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
