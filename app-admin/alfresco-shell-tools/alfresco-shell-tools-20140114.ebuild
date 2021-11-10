# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit git-r3

DESCRIPTION="Swiss army knife to to interact with Alfresco from the shell"
HOMEPAGE="https://code.google.com/p/alfresco-shell-tools/"
EGIT_REPO_URI="https://code.google.com/p/alfresco-shell-tools/"
EGIT_COMMIT="ed90c052eb7a"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="app-misc/jshon
	net-misc/curl
	app-shells/bash"

src_configure() {
	sed -i -e "s|\(^ALFTOOLS_BIN=\).*|\1${EPREFIX}/usr/share/${PN}|" bin/* || die
}

src_install() {
	exeinto /usr/share/${PN}
	insinto /usr/share/${PN}

	for s in bin/* ; do 
		if grep -q '#!/bin/bash' "${s}" ; then
			doexe "${s}"
			dosym "../share/${PN}/${s##*/}" "/usr/bin/${s##*/}"
		else
			doins "${s}"
		fi
	done
}
