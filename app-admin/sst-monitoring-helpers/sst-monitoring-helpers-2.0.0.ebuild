# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="stepping stone GmbH monitoring helper scripts"
HOMEPAGE="http://www.stepping-stone.ch/"
SRC_URI="https://github.com/stepping-stone/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=">=net-analyzer/zabbix-1.8.20"

src_install() {
	exeinto /usr/libexec/sst-monitoring-helpers
	doexe usr/libexec/sst-monitoring-helpers/*

	insinto /usr/share/sst-monitoring-helpers
	doins usr/share/sst-monitoring-helpers/*

	insinto /etc/zabbix/zabbix_agentd.d
	insopts -m0640 -o root -g zabbix
	doins etc/zabbix/zabbix_agentd.d/*

	insinto /etc/sst-monitoring-helpers
	insopts -m0644
	doins -r etc/sst-monitoring-helpers/*

	insinto /etc/sudoers.d
	doins etc/sudoers.d/*

	dodoc README.md
}

pkg_postinst() {
	chown root:zabbix \
		"${ROOT}"/etc/zabbix/zabbix_agentd.d
	chmod 750 \
		"${ROOT}"/etc/zabbix/zabbix_agentd.d
	mkdir -p -m0750 "${ROOT}"/var/cache/zabbix
	chown zabbix:zabbix \
		"${ROOT}"/var/cache/zabbix
}
