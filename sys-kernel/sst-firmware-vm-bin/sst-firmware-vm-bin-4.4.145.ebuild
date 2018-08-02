# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="stepping stone GmbH binary vm firmware, based on sys-kernel/gentoo-sources"
HOMEPAGE=""
SRC_URI="https://mirror.stepping-stone.ch/public/gentoo/binary-kernel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

src_install() {
	doins -r lib
}
