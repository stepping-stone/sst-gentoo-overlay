# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/newrelic-sysmond/newrelic-sysmond-1.1.2.124.ebuild,v 1.5 2012/12/15 16:53:46 pacho Exp $

EAPI=5

inherit user

DESCRIPTION="NewRelic System Monitor"
HOMEPAGE="http://www.newrelic.com/"
SRC_URI="http://download.newrelic.com/server_monitor/release/${P}-linux.tar.gz"

LICENSE="newrelic Apache-2.0 BSD MIT ISC openssl GPL-2 ZLIB"
SLOT="0"
KEYWORDS="~x86 amd64"
IUSE=""
RESTRICT="strip"

S="${WORKDIR}/${P}-linux"

pkg_setup() {
	enewuser newrelic
}

src_install() {
	if use amd64; then
		local arch="x64"
	elif use x86; then
		local arch="x86"
	else
		die "Unsupported architecture"
	fi

	into /opt/newrelic
	dobin "scripts/nrsysmond-config"
	newbin "daemon/nrsysmond.${arch}" "nrsysmond"

	newinitd "${FILESDIR}"/newrelic-sysmond.initd newrelic-sysmond
	newconfd "${FILESDIR}"/newrelic-sysmond.confd newrelic-sysmond

	keepdir "/etc/newrelic"
	insinto "/etc/newrelic"

	doins nrsysmond.cfg
	# The configuration will contain a personal licence key
	fowners root:newrelic /etc/newrelic/nrsysmond.cfg
	fperms 0640 /etc/newrelic/nrsysmond.cfg

	# Gentoo places PIDs below /run
	sed -i \
		-e "s|^#\?\(pidfile\)=.*|\1=/run/newrelic/nrsysmond.pid|" \
		"${D}"/etc/newrelic/nrsysmond.cfg || die "Sed failed"

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/newrelic.logrotate newrelic

	diropts -o newrelic -g newrelic
	keepdir "/var/log/newrelic"

	dodoc INSTALL.txt LICENSE.txt
}

pkg_postinst() {
	elog "Remember to set your license key via:"
	elog "/opt/newrelic/bin/nrsysmond-config --set license_key=\$YOUR_KEY"
}
