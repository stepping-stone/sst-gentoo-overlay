# Copyright 1999-2017 stepping stone GmbH
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A collection of useful scripts for Gentoo Linux"
HOMEPAGE="https://github.com/stepping-stone/sst-gentoo-tools"
SRC_URI="https://github.com/stepping-stone/${PN}/archive/${PV}.tar.gz -> ${PN}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

src_install() {
	newbin emerge-log-updates.py emerge-log-updates
	newbin emerge-release-jumps.sh emerge-release-jumps
	newbin emerge-updates.sh emerge-updates
	dodoc README.md
}
