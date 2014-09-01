# Copyright 1999-2013 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3

DESCRIPTION="stepping stone Bash library functions"
HOMEPAGE="https://github.com/stepping-stone/bash-libs"
EGIT_REPO_URI="https://github.com/stepping-stone/bash-libs.git"

LICENSE="EUPL-1.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="app-shells/bash"

src_install() {
	insinto /usr/share/stepping-stone/lib/bash
	doins *.lib.sh
}
