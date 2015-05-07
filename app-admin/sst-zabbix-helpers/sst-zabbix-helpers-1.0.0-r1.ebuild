# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_PN="zabbix-helpers"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="stepping stone GmbH Zabbix agent configuration"
HOMEPAGE="http://www.stepping-stone.ch/"
SRC_URI="https://github.com/stepping-stone/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=">=net-analyzer/zabbix-1.8.20"

S="${WORKDIR}/${MY_P}"

src_install() {
    exeinto /usr/libexec/zabbix
    doexe usr/libexec/zabbix/*

    insinto /etc/zabbix/zabbix_agentd.d
    insopts -m0640 -o root -g zabbix
    doins etc/zabbix/zabbix_agentd.d/*

    insinto /etc/sudoers.d
    doins etc/sudoers.d/*

    dodoc README.md
}

pkg_postinst() {
    chown root:zabbix \
        "${ROOT}"/etc/zabbix/zabbix_agentd.d
    chmod 750 \
        "${ROOT}"/etc/zabbix/zabbix_agentd.d
}
