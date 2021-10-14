# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ncurses"

inherit bash-completion-r1 git-r3

DESCRIPTION="Command-line interface to Phabricator"
HOMEPAGE="https://github.com/phacility/arcanist"
EGIT_REPO_URI="https://github.com/phacility/arcanist.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/php
	dev-php/libphutil
	dev-python/pycodestyle"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	dodoc README.md

	newbashcomp resources/shell/bash-completion ${PN}
	rm -r resources/shell || die

	insinto /usr/share/php/arcanist
	doins -r resources scripts src

	python_optimize "${D}/usr/share/php/arcanist/scripts"

	fperms 0755 /usr/share/php/arcanist/scripts/arcanist.php
	dosym ../share/php/arcanist/scripts/arcanist.php /usr/bin/arc
}
