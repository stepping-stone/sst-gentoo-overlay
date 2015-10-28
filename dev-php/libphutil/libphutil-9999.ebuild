# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils git-r3

DESCRIPTION="Collection of utility classes and functions for PHP."
HOMEPAGE="https://github.com/phacility/libphutil"
EGIT_REPO_URI="https://github.com/phacility/libphutil.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-lang/php:*[curl]"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/9999-respect-flags.patch"
}

src_compile() {
	emake -C support/xhpast/
}

src_install() {
	dobin support/xhpast/xhpast

	insinto /usr/share/doc/${PF}
	doins -r scripts/example
	rm -r scripts/example

	dodoc README.md

	insinto /usr/share/php/libphutil
	doins -r externals scripts src

	insinto /usr/share/php/libphutil/support
	doins -r support/phutiltestlib

	insinto /usr/share/php/libphutil/support/xhpast
	doins support/xhpast/*.php

	# some scripts must be executable
	fperms 0755 /usr/share/php/libphutil/scripts/daemon/exec/exec_daemon.php
}
