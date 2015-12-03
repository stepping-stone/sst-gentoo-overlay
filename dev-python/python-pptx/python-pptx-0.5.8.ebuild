# Copyright 1999-2015 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="A python library for creating and updating PowerPoint (.pptx) files."
HOMEPAGE="https://python-pptx.readthedocs.org/"
SRC_URI="http://pypi.python.org/packages/source/p/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/pillow
        dev-python/lxml
        dev-python/flake8
        dev-python/xlsxwriter"
RDEPEND="${DEPEND}"
