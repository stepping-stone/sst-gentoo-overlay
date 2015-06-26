# Copyright 1999-2015 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_PN="syslog-ng"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="stepping stone GmbH syslog-ng configuration"
HOMEPAGE="http://www.stepping-stone.ch/"
SRC_URI="http://github.com/stepping-stone/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EUPL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=">=app-admin/syslog-ng-3.6"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup log
}

src_install() {
	insinto /etc/syslog-ng
	doins -r *

	keepdir /var/log/syslog
}
