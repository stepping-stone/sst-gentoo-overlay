# Copyright 2015 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU Affero General Public Licence v3
# $Header: $

EAPI=5

PHP_EXT_NAME="newrelic"
USE_PHP="php5-3 php5-4 php5-5 php5-6"

MY_PN="${PHP_EXT_NAME}-php5"
MY_P="${MY_PN}-${PV}-linux"
S="${WORKDIR}/${MY_P}"

inherit php-ext-source-r2 user

DESCRIPTION="New Relic PHP Agent"
HOMEPAGE="http://newrelic.com/"
SRC_URI="https://download.newrelic.com/php_agent/release/${MY_P}.tar.gz"

LICENSE="newrelic Apache-2.0 BSD MIT openssl PCRE PHP-3.01 ZLIB"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-lang/php[cli]
	sys-apps/grep[pcre]"
RDEPEND="dev-lang/php"

php_get_information() {
	${PHPCLI} -i 2> /dev/null | grep -Po "(?<=^${1} => ).*$"
}

pkg_setup() {
	enewuser "newrelic"
}

src_prepare() {
	true; # skip exported php-ext-source-r2_src_prepare() function
}

src_configure() {
	true; # skip exported php-ext-source-r2_src_configure() function
}

src_compile() {
	true; # skip exported php-ext-source-r2_src_compile() function
}

src_install() {
	dodoc "README" "scripts/newrelic.ini.template"

	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}

		test -f ${PHPCLI} || die "Missing PHP binary: '${PHPCLI}'"
		PHP_EXTENSION="$( php_get_information "PHP Extension" )"
		PHP_ZTS="$( php_get_information "Thread Safety" )"

		if [[ "${PHP_EXTENSION}" == "enabled" ]]; then
			local extension_file="${PHP_EXT_NAME}-${PHP_EXTENSION}-zts.so"
		else
			local extension_file="${PHP_EXT_NAME}-${PHP_EXTENSION}.so"
		fi

		if use amd64; then
			local arch="x64"
		elif use x86; then
			local arch="x86"
		else
			die "Unsupported architecture"
		fi

		insinto "${EXT_DIR}"
		newins agent/${arch}/${extension_file} "${PHP_EXT_NAME}.so"
	done

	local daemon_pid="/run/newrelic-daemon/newrelic-daemon.pid"
	local daemon_socket="/run/newrelic-daemon/newrelic.sock"

	php-ext-source-r2_createinifiles

	# Addding required ini options which do not have a (sane) default value.
	php-ext-source-r2_addtoinifiles "[newrelic]"
	php-ext-source-r2_addtoinifiles "newrelic.license" "REPLACE_WITH_REAL_KEY"

	php-ext-source-r2_addtoinifiles "newrelic.logfile" \
									"/var/log/newrelic/php_agent.log"

	php-ext-source-r2_addtoinifiles "newrelic.appname" "PHP Application"

	php-ext-source-r2_addtoinifiles "newrelic.daemon.logfile" \
	 								"/var/log/newrelic/newrelic-daemon.log"

	php-ext-source-r2_addtoinifiles "newrelic.daemon.port" "${daemon_socket}"
	php-ext-source-r2_addtoinifiles "newrelic.daemon.pidfile" "${daemon_pid}"

	php-ext-source-r2_addtoinifiles "newrelic.daemon.location" \
	  								"/opt/newrelic/bin/newrelic-daemon"

	exeinto /opt/newrelic/bin

	# strip-off the arch suffix
	newexe daemon/newrelic-daemon.${arch} newrelic-daemon
	newexe scripts/newrelic-iutil.${arch} newrelic-iutil

	insinto /etc/newrelic
	newins scripts/newrelic.cfg.template newrelic.cfg

	# Gentoo places PIDs and sockets below /run
	sed -i \
		-e "s|^#\?\(pidfile\)=.*|\1=${daemon_pid}|" \
		-e "s|^#\?\(port\)=.*|\1=${daemon_socket}|" \
		"${D}"/etc/newrelic/newrelic.cfg || die "Sed failed"

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/newrelic.logrotate newrelic

	newinitd "${FILESDIR}"/newrelic-daemon.initd newrelic-daemon
	newconfd "${FILESDIR}"/newrelic-daemon.confd newrelic-daemon

	diropts -o newrelic -g newrelic
	keepdir /var/log/newrelic
}

pkg_postinst() {
	einfo "Make sure to replace the newrelic.license value with your real key"
	einfo "and also set the newrelic.appname to match your application's name"
	einfo "within /etc/php/*/ext/newrelic.ini"
	einfo ""
	einfo "The newrelic daemon can be started with the provided init-script"
	einfo "/etc/init.d/newrelic-daemon start"
}
