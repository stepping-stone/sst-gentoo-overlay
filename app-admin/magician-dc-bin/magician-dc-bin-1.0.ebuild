# Copyright 2015 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU Affero General Public License v3
# $Header: $

EAPI=5

DESCRIPTION="Samsung SSD Magician DC"
HOMEPAGE="http://www.samsung.com/global/business/semiconductor/minisite/SSD/global/html/support/server_downloads.html"

MY_PN="samsung_${PN/-dc-bin/_dc}"
MY_PV="v${PV}_rtm_p2"
MY_P="${MY_PN}-${MY_PV}"

SRC_URI="http://www.samsung.com/global/business/semiconductor/minisite/SSD/downloads/software/${MY_P}.tar.gz"

LICENSE="Samsung-Magician-Software-EULA BSD-2 public-domain"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	if use amd64; then
		local archFolder="64bin"
	elif use x86; then
		local archFolder="32bin"
	else
		die "Unsupported architecture"
	fi

	exeinto /opt/bin
	doexe "${archFolder}/magician"
}
