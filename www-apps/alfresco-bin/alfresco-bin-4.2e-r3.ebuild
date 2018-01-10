# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils user

MY_PV="${PV%?}.${PV: -1}"  # ex. 4.2b -> 4.2.b
MY_P="alfresco-community-${MY_PV}"

DESCRIPTION="Alfresco Open Source Enterprise Content Management System"
HOMEPAGE="http://alfresco.com/"
SRC_URI="mirror://sourceforge/alfresco/${MY_P}.zip"

LICENSE="LGPL-3"
SLOT="4.2"
KEYWORDS="~x86 ~amd64"
IUSE="+postgres +imagemagick +share ooodirect"

TOMCAT_SLOT="7"

DEPEND="app-arch/unzip
	virtual/jre:1.8"
RDEPEND="virtual/jre:1.8
	>=www-servers/tomcat-7.0.29:${TOMCAT_SLOT}
	media-gfx/swftools
	postgres? ( dev-java/jdbc-postgresql )
	imagemagick? ( media-gfx/imagemagick[jpeg,png,postscript,truetype] )
	ooodirect? (
		|| ( app-office/libreoffice
			app-office/libreoffice-bin
			app-office/openoffice-bin ) )"

S="${WORKDIR}"

MY_NAME="alfresco-${SLOT}"
MY_USER="alfresco"
MY_GROUP="alfresco"

TOMCAT_HOME="/usr/share/tomcat-${TOMCAT_SLOT}"
DEST_DIR="/opt/${MY_NAME}"
CONF_DIR="/etc/${MY_NAME}"

pkg_setup() {
	ebegin "Creating alfresco user and group"
	enewgroup ${MY_GROUP}
	enewuser ${MY_USER} -1 /bin/sh "/opt/${MY_NAME}" ${MY_GROUP}
}

src_prepare() {
	# fix permissions
	chmod -R a-x,a+X bin web-server
}

src_install() {
	local conf="${CONF_DIR}"
	local dest="${DEST_DIR}"
	local logs="/var/log/${MY_NAME}"
	local temp="/var/lib/${MY_NAME}/tmp"
	local data="/var/lib/${MY_NAME}/data"
	local work="/var/lib/${MY_NAME}/work"

	local user="${MY_USER}"
	local group="${MY_GROUP}"

	### Prepare directories ###

	diropts -m700
	keepdir "${data}"
	dodir "${work}" "${temp}"

	diropts -m750
	dodir "${conf}"/Catalina/localhost

	diropts -m755
	keepdir "${conf}" "${logs}" "${dest}"/amps

	dosym "${conf}" "${dest}"/conf
	dosym "${logs}" "${dest}"/logs
	dosym "${temp}" "${dest}"/temp
	dosym "${work}" "${dest}"/work

	### Copy files ###

	insinto "${dest}"/bin
	exeinto "${dest}"/bin

	doins bin/*.jar

	sed -i \
		-e "s|tomcat/temp/|${temp}/|g" \
		-e "s|tomcat/work/|${work}/|g" \
		bin/clean_tomcat.sh \
		|| "failed to filter clean_tomcat.sh"
	doexe bin/clean_tomcat.sh

	cp "${FILESDIR}"/generate_keystores.sh "${T}" || die
	sed -i -e "s|@CONF_DIR@|${conf}|" \
		"${T}"/generate_keystores.sh \
		|| "failed to filter generate_keystores.sh"
	doexe "${T}"/generate_keystores.sh

	insinto "${dest}"
	doins -r web-server/endorsed
	insinto "${conf}"
	doins -r web-server/shared/classes

	cd web-server || die

	### Deploy WARs ###

	local webapps="${WORKDIR}/web-server/webapps"

	# fix logs location inside WARs
	# it is shame that this cannot be configured externally...
	local key='log4j.appender.File.File'
	local prefix='${catalina.base}/logs/'

	local wars="alfresco"
	use share && wars+=" share"

	for war in ${wars} ; do
		einfo "Extracting ${war}.war ..."
		dodir "${dest}/webapps/${war}"
		pushd "${D}/${dest}/webapps/${war}" >/dev/null
		jar -xf "${webapps}/${war}.war" || die "failed to extract ${war}.war"
		popd >/dev/null

		einfo "Patching log4j.properties ..."
		sed -i \
			-e "s|\(${key}=\)\(.*/\)\?\([\w\.]*\)|\1${prefix}\3|" \
			"${D}/${dest}/webapps/${war}/WEB-INF/classes/log4j.properties" || die "failed to modify log4j.properties for ${war}"
	done

	# Backport of fix for https://issues.alfresco.com/jira/browse/ALF-17221
	insinto /${dest}/webapps/share/js
	doins "${FILESDIR}"/alfresco{,-min}.js

	## Copy default keystores from alfresco.war ##

	local _keystore="WEB-INF/classes/alfresco/keystore"

	cd "${T}"
	jar xf "${webapps}"/alfresco.war "$_keystore" \
		|| die "failed to extract $_keystore from alfresco.war"
	rm "$_keystore"/{CreateSSLKeystores.txt,generate_keystores.*}

	insinto "${conf}"/keystore
	doins "$_keystore"/*

	cd "${WORKDIR}"/web-server

	### Configs ###

	insinto "${conf}"

	## Filter and install catalina.properties ##

	local tfile="catalina.properties"

	cp "${TOMCAT_HOME}/conf/${tfile}" \
		"${T}" || die "failed to copy ${tfile} from ${TOMCAT_HOME}/conf"

	# add classpaths to shared classloader
	local path="${conf}/classes,\${catalina.base}/shared/lib/\*\.jar"
	sed -i \
		-e "s|.*\(shared.loader=\).*|\1${path}|" \
		"${T}/${tfile}" \
		|| die "failed to filter ${tfile}"

	doins "${T}/${tfile}"

	## Filter and install tomcat-logging.properties ##

	local tfile="tomcat-logging.properties"

	cp "${FILESDIR}/${tfile}" "${T}" || die
	sed -i \
		-e "s|@LOG_DIR@|${logs}|" \
		"${T}/${tfile}" || die "failed to filter ${tfile}"

	doins "${T}/${tfile}"

	## Filter and install server.xml ##

	local tfile="server.xml"
	local randpw=$(echo ${RANDOM}|md5sum|cut -c 1-15)

	cp "${FILESDIR}/${tfile}" "${T}" || die

	# replace the default password with a random one
	sed -i \
		-e "s|@SHUTDOWN@|${randpw}|" \
		-e "s|@LOG_DIR@|${logs}|" \
		"${T}/${tfile}" || die "failed to filter ${tfile}"

	doins "${T}/${tfile}"

	## Filter and install alfresco-global.properties ##

	local tfile="alfresco-global.properties"

	cp "${FILESDIR}/${tfile}" "${T}" || die

	sed -i \
		-e "s|@DATA_DIR@|${data}|" \
		-e "s|@CONF_DIR@|${conf}|" \
		"${T}/${tfile}" || die "failed to filter ${tfile}"

	# enable OOoDirect if USEd
	if use ooodirect; then
		sed -i -e "s|.*\(ooo.enabled=\).*|\1true|" \
			"${T}/${tfile}" \
			|| die "failed to filter ${tfile}"
	fi

	insinto "${conf}/classes"
	doins "${T}/${tfile}"

	## Install tomcat-users.xml ##

	insinto "${conf}"
	doins "${FILESDIR}"/tomcat-users.xml

	## Make symlinks ##

	dosym "${TOMCAT_HOME}"/conf/web.xml "${conf}"/web.xml

	### Fix permissions ###

	fowners -R ${user}:${group} "${temp}" "${work}" "${logs}" "${data}"
	fowners -R root:${group} "${conf}"
	fperms 640 "${conf}"/{server.xml,tomcat-users.xml,classes/alfresco-global.properties}
	fperms 600 "${conf}"/keystore/ssl-{key,trust}store-passwords.properties

	### RC scripts ###

	cp "${FILESDIR}"/alfresco-tc.conf "${T}" || die
	local tfile="${T}"/alfresco-tc.conf

	local path; for path in "${FILESDIR}"/alfresco-tc.*; do
		cp "${path}" "${T}" || die
		local tfile="${T}"/`basename ${path}`
		sed -i \
			-e "s|@CATALINA_HOME@|${TOMCAT_HOME}|" \
			-e "s|@CATALINA_BASE@|${dest}|" \
			-e "s|@EXTRA_JARS@|${jdbc_jar}|" \
			-e "s|@TEMP_DIR@|${temp}|" \
			-e "s|@CONF_DIR@|${conf}|" \
			-e "s|@USER@|${user}|" \
			-e "s|@GROUP@|${group}|" \
			-e "s|@NAME@|Alfresco ${SLOT}|" \
			"${tfile}" \
			|| die "failed to filter `basename ${path}`"
	done

	newinitd "${T}"/alfresco-tc.init "${MY_NAME}"
	newconfd "${T}"/alfresco-tc.conf "${MY_NAME}"

	### Logrotate config ###

	insinto /etc/logrotate.d

	## Filter and install the Alfresco logrotate config ##

	local tfile="alfresco.logrotate"

	cp "${FILESDIR}/${tfile}" "${T}" || die

	sed -i \
		-e "s|@LOG_DIR@|${logs}|" \
		"${T}/${tfile}" || die "failed to filter ${tfile}"

	newins "${T}/${tfile}" alfresco
}

pkg_postinst() {
	elog "Alfresco ${SLOT} requires a SQL database to run. You have to edit"
	elog "'${CONF_DIR}/classes/alfresco-global.properties' and then"
	elog "create role and database for your Alfresco instance."
	elog

	if use postgres; then
		elog "If you have local PostgreSQL running, you can just copy&run:"
		elog "    su postgres"
		elog "    psql -c \"CREATE ROLE alfresco PASSWORD 'alfresco' \\"
		elog "        NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;\""
		elog "    createdb -E UTF-8 -O alfresco alfresco"
		elog "Note: You should change your password to something more random..."
	else
		ewarn "Since you have not set any database USE flag, you need to install"
		ewarn "an appropriate JDBC driver and add it to TOMCAT_EXTRA_JARS in"
		ewarn "'/etc/conf.d/${MY_NAME}'."
	fi

	elog
	elog "Keystores in ${CONF_DIR}/keystore was populated with"
	elog "default certificates provided by Alfresco, Ltd. If you are going to"
	elog "use SOLR, in production environment, you should generate your own"
	elog" certificates and keystores. You can use provided script:"
	elog "    ${DEST_DIR}/bin/generate_keystores.sh"
}
