# Copyright 1999-2015 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit php-pear-r2 eutils

DESCRIPTION="Package for generating Excel spreadsheets"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64"
RDEPEND="dev-lang/php[iconv]
	>=dev-php/PEAR-OLE-0.5-r1"

src_prepare() {
	cd "${P%%-r[0-9]}"
	epatch "${FILESDIR}/fix-call-time-pass-by-reference.patch"
}
