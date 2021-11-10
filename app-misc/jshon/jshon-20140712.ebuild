# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit git-r3

DESCRIPTION="parses, reads and creates JSON"
HOMEPAGE="http://kmkeen.com/jshon/"
EGIT_REPO_URI="https://github.com/keenerd/jshon.git"
EGIT_COMMIT="a61d7f2f85f4627bc3facdf951746f0fd62334b7"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-libs/jansson"
RDEPEND="${DEPEND}"
