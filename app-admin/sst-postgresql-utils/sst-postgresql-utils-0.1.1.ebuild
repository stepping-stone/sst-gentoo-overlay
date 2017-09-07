# Copyright 1999-2013 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="stepping stone PostgreSQL related scripts"
HOMEPAGE="https://github.com/stepping-stone/postgresql-utils"
SRC_URI="http://github.com/stepping-stone/${PN#sst-}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EUPL-1.1"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="app-shells/bash"

S="${WORKDIR}/${P#sst-}"

src_install() {
	dobin usr/bin/*
}
