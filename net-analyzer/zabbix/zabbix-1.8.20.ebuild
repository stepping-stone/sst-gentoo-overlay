# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

# needed to make webapp-config dep optional
WEBAPP_OPTIONAL="yes"
WEBAPP_MANUAL_SLOT="yes"

inherit eutils webapp user

MY_P=${P/_/}

DESCRIPTION="ZABBIX is software for monitoring of your applications, network and servers."
HOMEPAGE="http://www.zabbix.com/"
SRC_URI="mirror://sourceforge/zabbix/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+agent curl frontend ipv6 jabber ldap mysql openipmi postgres proxy server ssh snmp +sqlite iodbc odbc"
REQUIRED_USE="server? ( ^^ ( mysql postgres sqlite ) )
	proxy? ( ^^ ( mysql postgres sqlite ) )
	|| ( agent frontend proxy server )"

COMMON_DEPEND="snmp? ( net-analyzer/net-snmp )
	ldap? (
		net-nds/openldap
		dev-libs/cyrus-sasl:2=
		net-libs/gnutls:= )
	mysql? ( virtual/mysql )
	sqlite? ( dev-db/sqlite:3 )
	postgres? ( dev-db/postgresql-base )
	jabber? ( dev-libs/iksemel )
	curl? ( net-misc/curl )
	openipmi? ( sys-libs/openipmi )
	ssh? ( net-libs/libssh2 )
	odbc? (
		iodbc? ( dev-db/libiodbc )
		!iodbc? ( dev-db/unixODBC ) )"

RDEPEND="${COMMON_DEPEND}
	proxy? ( >=net-analyzer/fping-3 )
	server? ( >=net-analyzer/fping-3 app-admin/webapp-config )
	frontend? ( dev-lang/php[bcmath,ctype,sockets,gd,truetype,xml,session]
		media-libs/gd[png]
		app-admin/webapp-config
		virtual/httpd-php )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

pkg_setup() {
	if use frontend; then
		webapp_pkg_setup
	fi

	enewgroup zabbix
	enewuser zabbix -1 -1 /var/lib/zabbix/home zabbix
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.8.12-fping3.patch"
}

src_configure() {
	local myconf

	if use odbc && use iodbc ; then
	   myconf="${myconf} --with-iodbc --without-unixodbc"
	elif use odbc && ! use iodbc; then
	   myconf="${myconf} --with-unixodbc --without-iodbc"
	else
	   myconf="${myconf} --without-unixodbc --without-iodbc"
	fi

	econf \
		$myconf \
		--without-oracle \
		--disable-static \
		$(use_enable server) \
		$(use_enable proxy) \
		$(use_enable agent) \
		$(use_enable ipv6) \
		$(use_with ldap) \
		$(use_with snmp net-snmp) \
		$(use_with mysql) \
		$(use_with postgres pgsql) \
		$(use_with sqlite sqlite3) \
		$(use_with jabber) \
		$(use_with curl libcurl) \
		$(use_with openipmi openipmi) \
		$(use_with ssh ssh2)
}

src_install() {
	keepdir \
		/etc/zabbix \
		/var/lib/zabbix{,/home,/scripts} \
		/var/log/zabbix

	fowners zabbix:zabbix \
		/etc/zabbix \
		/var/lib/zabbix{,/home,/scripts} \
		/var/log/zabbix
	fperms 0750 \
		/etc/zabbix \
		/var/lib/zabbix{,/home,/scripts} \
		/var/log/zabbix

	dodoc README NEWS ChangeLog

	if use server; then
		newinitd "${FILESDIR}/zabbix-server.initd" zabbix-server

		dosbin src/zabbix_server/zabbix_server
		
		insinto /etc/zabbix
		doins "${FILESDIR}"/zabbix_{server,trapper}.conf
		fowners zabbix:zabbix /etc/zabbix/zabbix_{server,trapper}.conf
		fperms 0640 /etc/zabbix/zabbix_{server,trapper}.conf

		insinto /usr/share/zabbix/database
		doins -r upgrades create
	fi

	if use proxy; then
		newinitd "${FILESDIR}/zabbix-proxy.initd" zabbix-proxy

		dosbin src/zabbix_proxy/zabbix_proxy

		insinto /etc/zabbix
		doins "${FILESDIR}/zabbix_proxy.conf"

		insinto /usr/share/zabbix/database
		doins -r upgrades create
	fi

	if use agent; then
		dosbin src/zabbix_agent/zabbix_agent{,d}
		dobin \
			src/zabbix_sender/zabbix_sender \
			src/zabbix_get/zabbix_get

		newinitd "${FILESDIR}/zabbix-agentd.initd" zabbix-agentd

		insinto /etc/zabbix
		doins "${FILESDIR}"/zabbix_agent{,d}.conf
		fowners zabbix:zabbix /etc/zabbix/zabbix_agent{,d}.conf
		fperms 0640 /etc/zabbix/zabbix_agent{,d}.conf
	fi

	if use frontend; then
		webapp_src_preinst
		cp -R frontends/php/* "${D}/${MY_HTDOCSDIR}"
		webapp_postinst_txt en "${FILESDIR}/postinstall-en.txt"
		webapp_configfile \
			"${MY_HTDOCSDIR}"/include/db.inc.php \
			"${MY_HTDOCSDIR}"/include/config.inc.php
		webapp_src_install
	fi
}

pkg_postinst() {
	if use server || use proxy ; then
		elog
		elog "You need to configure your database for Zabbix."
		elog
		elog "Have a look at /usr/share/zabbix/database for"
		elog "database creation and upgrades."
		elog
		elog "For more info read the Zabbix manual at"
		elog "http://www.zabbix.com/documentation.php"
		elog

		zabbix_homedir=$(egethome zabbix)
		if [ -n "${zabbix_homedir}" ] && \
		   [ "${zabbix_homedir}" != "/var/lib/zabbix/home" ]; then
			ewarn
			ewarn "The user 'zabbix' should have his homedir changed"
			ewarn "to /var/lib/zabbix/home if you want to use"
			ewarn "custom alert scripts."
			ewarn
			ewarn "A real homedir might be needed for configfiles"
			ewarn "for custom alert scripts (e.g. ~/.sendxmpprc when"
			ewarn "using sendxmpp for Jabber alerts)."
			ewarn
			ewarn "To change the homedir use:"
			ewarn "  usermod -d /var/lib/zabbix/home zabbix"
			ewarn
		fi
	fi

	if use server; then
		elog
		elog "For distributed monitoring you have to run:"
		elog
		elog "zabbix_server -n <nodeid>"
		elog
		elog "This will convert database data for use with Node ID"
		elog "and also adds a local node."
		elog
	fi

	elog "--"
	elog
	elog "Add these lines in the /etc/services :"
	elog
	elog "zabbix-agent     10050/tcp Zabbix Agent"
	elog "zabbix-agent     10050/udp Zabbix Agent"
	elog "zabbix-trapper   10051/tcp Zabbix Trapper"
	elog "zabbix-trapper   10051/udp Zabbix Trapper"
	elog

	# repeat fowners/fperms functionality from src_install()
	# here to catch wrong permissions on existing files in
	# the live filesystem (yeah, that sucks).
	chown -R zabbix:zabbix \
		"${ROOT}"/etc/zabbix \
		"${ROOT}"/var/lib/zabbix{,/home,/scripts} \
		"${ROOT}"/var/log/zabbix
	chmod 0750 \
		"${ROOT}"/etc/zabbix \
		"${ROOT}"/var/lib/zabbix{,/home,/scripts} \
		"${ROOT}"/var/log/zabbix

	chmod 0640 "${ROOT}"/etc/zabbix/zabbix_*

	if use server || use proxy ; then
		# check for fping
		fping_perms=$(stat -c %a /usr/sbin/fping 2>/dev/null)
		case "${fping_perms}" in
			4[157][157][157])
				;;
			*)
				ewarn "If you want to use the checks 'icmpping' and 'icmppingsec',"
				ewarn "you have to make /usr/sbin/fping setuid root and executable"
				ewarn "by everyone. Run the following command to fix it:"
				ewarn
				ewarn "  chmod u=rwsx,g=rx,o=rx /usr/sbin/fping"
				ewarn
				ewarn "Please be aware that this might impose a security risk,"
				ewarn "depending on the code quality of fping."
				;;
		esac
	fi
}
