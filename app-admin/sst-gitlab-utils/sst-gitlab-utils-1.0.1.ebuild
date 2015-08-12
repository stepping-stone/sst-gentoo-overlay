# Copyright 2015 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="stepping stone GitLab related scripts"
HOMEPAGE="https://github.com/stepping-stone/gitlab-utils"
SRC_URI="http://github.com/stepping-stone/${PN#sst-}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="postgres"

DEPEND=""
RDEPEND="app-shells/bash
	>=dev-libs/sst-bash-libs-1.4.0
	postgres? ( app-admin/sst-postgresql-utils )"

S="${WORKDIR}/${P#sst-}"

src_install() {
	insinto /usr
	dosbin usr/sbin/*

	exeinto /usr/libexec/gitlab-utils
	doexe usr/libexec/gitlab-utils/*

	insinto /etc
	doins etc/*

	dodoc README.md
}
