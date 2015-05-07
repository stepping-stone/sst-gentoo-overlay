# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Web frontend for PuppetDB"
HOMEPAGE="https://github.com/puppet-community/puppetboard"
SRC_URI="https://pypi.python.org/packages/source/p/puppetboard/puppetboard-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/flask
        dev-python/flask-wtf
        dev-python/jinja
        dev-python/markupsafe
        dev-python/wtforms
        dev-python/werkzeug
        dev-python/itsdangerous
        dev-python/requests"
RDEPEND="${DEPEND}"
