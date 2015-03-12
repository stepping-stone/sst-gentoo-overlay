# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit subversion versionator

DESCRIPTION="Command-line flags module for Unix shell scripts"
HOMEPAGE="http://code.google.com/p/shflags/"
ESVN_REPO_URI="http://shflags.googlecode.com/svn/trunk/source/$(get_version_component_range 1-2)"
ESVN_REVISION="${PV##*_pre}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

src_test() {
	cd src
	./shflags_test.sh || die
}

src_install() {
	dohtml README.html
	dodoc README.txt doc/*.txt
	insinto /usr/share/misc
	doins src/shflags
	use examples && dodoc examples/*.sh
}
