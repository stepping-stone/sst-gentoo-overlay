# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit git-r3 webapp

DESCRIPTION="An open source, software engineering platform"
HOMEPAGE="http://phabricator.org/"
EGIT_REPO_URI="https://github.com/phacility/phabricator.git"

LICENSE="Apache-2.0"
KEYWORDS=""
IUSE="git subversion"

DEPEND=""
RDEPEND="dev-vcs/arcanist
	dev-php/libphutil
	virtual/httpd-php
	dev-lang/php[iconv,curl,pcntl]
	|| ( dev-lang/php[mysql] dev-lang/php[mysqli] )
	git? ( dev-vcs/git[cgi] )
	subversion? ( dev-vcs/subversion )"

src_install() {
	webapp_src_preinst
	
	dodoc README.md NOTICE

	cp -R \
		bin conf externals resources scripts src support webroot \
		"${D}/${MY_HTDOCSDIR}" || die

	webapp_postinst_txt en "${FILESDIR}/postinstall-en.txt"

	webapp_src_install
}
