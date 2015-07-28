# Copyright 1999-2014 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="stepping stone Bash library functions"
HOMEPAGE="https://github.com/stepping-stone/bash-libs"
SRC_URI="http://github.com/stepping-stone/${PN#sst-}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EUPL-1.1"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="app-shells/bash"

S="${WORKDIR}/${P#sst-}"

src_install() {
	insinto /usr/share/stepping-stone/lib/bash
	doins *.lib.sh
}
