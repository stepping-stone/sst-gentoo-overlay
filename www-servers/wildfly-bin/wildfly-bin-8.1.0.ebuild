# Copyright 2014 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU Affero General Public License v3
# $Header: $

EAPI=5

inherit eutils java-pkg-2 user

MY_PN="wildfly"
MY_PV="${PV}.Final"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="WildFly is a flexible, lightweight, managed application runtime"
HOMEPAGE="http://www.wildfly.org"
SRC_URI="http://download.jboss.org/${MY_PN}/${MY_PV}/${MY_P}.tar.gz"

LICENSE="LGPL"
SLOT="8"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jdk-1.7"
DEPEND=""

S="${WORKDIR}/${MY_P}"

WILDFLY_USER="wildfly"
WILDFLY_GROUP="wildfly"

WILDFLY_NAME="${PN}-${SLOT}"
WILDFLY_HOME_DIR="/opt/${WILDFLY_NAME}"

DEFAULT_INSTANCE_NAME="default"

WILDFLY_BASE_ROOT="/var/lib/${WILDFLY_NAME}"
WILDFLY_CONF_ROOT="/etc/${WILDFLY_NAME}"
WILDFLY_LOG_ROOT="/var/log/${WILDFLY_NAME}"
WILDFLY_TMP_ROOT="/var/tmp/${WILDFLY_NAME}"

WILDFLY_DEFAULT_BASE_DIR="${WILDFLY_BASE_ROOT}/${DEFAULT_INSTANCE_NAME}"
WILDFLY_DEFAULT_CONF_DIR="${WILDFLY_CONF_ROOT}/${DEFAULT_INSTANCE_NAME}"
WILDFLY_DEFAULT_LOG_DIR="${WILDFLY_LOG_ROOT}/${DEFAULT_INSTANCE_NAME}"
WILDFLY_DEFAULT_TMP_DIR="${WILDFLY_TMP_ROOT}/${DEFAULT_INSTANCE_NAME}"

pkg_setup() {
	enewgroup "${WILDFLY_GROUP}"
	enewuser "${WILDFLY_USER}" "-1" "-1" "-1" "${WILDFLY_GROUP}"
}

java-pkg-2_src_compile() {
	# Nothing to build for this bin package
	return 0
}

src_install() {
	# Wildfly core installation
	java-pkg_dojar jboss-modules.jar

	insinto "${WILDFLY_DEFAULT_CONF_DIR}/appclient"
	doins appclient/configuration/*.xml appclient/configuration/*.properties

	exeinto "${WILDFLY_HOME_DIR}/bin"
	doexe bin/jconsole.sh

	# Install configuration files in the conf directory instead of bin
	insinto "${WILDFLY_DEFAULT_CONF_DIR}"
	doins bin/appclient.conf bin/*.xml bin/*.properties

	insinto "${WILDFLY_HOME_DIR}/bin/client"
	doins bin/client/*.jar

	# Install Gentooified launchers instead of the origianl shell scripts
	local java_args="
		-Djboss.home.dir=${WILDFLY_HOME_DIR}
		-Djboss.server.base.dir=${WILDFLY_BASE_ROOT}/\${WILDFLY_INSTANCE:=${DEFAULT_INSTANCE_NAME}}/standalone
		-Djboss.server.config.dir=${WILDFLY_CONF_ROOT}/\${WILDFLY_INSTANCE:=${DEFAULT_INSTANCE_NAME}}/standalone
		-Djboss.server.config.user.dir=${WILDFLY_CONF_ROOT}/\${WILDFLY_INSTANCE:=${DEFAULT_INSTANCE_NAME}}/standalone
		-Djboss.server.log.dir=${WILDFLY_LOG_ROOT}/\${WILDFLY_INSTANCE:=${DEFAULT_INSTANCE_NAME}}/standalone
		-Djboss.server.temp.dir=${WILDFLY_TMP_ROOT}/\${WILDFLY_INSTANCE:=${DEFAULT_INSTANCE_NAME}}/standalone
		-Djboss.domain.base.dir=${WILDFLY_BASE_ROOT}/\${WILDFLY_INSTANCE:=${DEFAULT_INSTANCE_NAME}}/domain
		-Djboss.domain.config.dir=${WILDFLY_CONF_ROOT}/\${WILDFLY_INSTANCE:=${DEFAULT_INSTANCE_NAME}}/domain
		-Djboss.domain.config.user.dir=${WILDFLY_CONF_ROOT}/\${WILDFLY_INSTANCE:=${DEFAULT_INSTANCE_NAME}}/domain
		-Djboss.domain.log.dir=${WILDFLY_LOG_ROOT}/\${WILDFLY_INSTANCE:=${DEFAULT_INSTANCE_NAME}}/domain
		-Djboss.domain.temp.dir=${WILDFLY_TMP_ROOT}/\${WILDFLY_INSTANCE:=${DEFAULT_INSTANCE_NAME}}/domain"

	# add-user.sh launcher
	java-pkg_dolauncher \
		add-user.sh \
		--main org.jboss.modules.Main \
		--java_args "\${JAVA_OPTS} ${java_args}" \
		--pkg_args \
			"-mp ${WILDFLY_HOME_DIR}/modules org.jboss.as.domain-add-user" \
		-into "${WILDFLY_HOME_DIR}"

	# appclient.sh launcher
	java-pkg_dolauncher \
		appclient.sh \
		--main org.jboss.modules.Main \
		--java_args \
			"\${JAVA_OPTS}
			${java_args}
		    -Dorg.jboss.boot.log.file=${WILDFLY_LOG_ROOT}/\${WILDFLY_INSTANCE:=${DEFAULT_INSTANCE_NAME}}/appclient.log
			-Dlogging.configuration=file:${WILDFLY_CONF_ROOT}/\${WILDFLY_INSTANCE:=${DEFAULT_INSTANCE_NAME}}/appclient/logging.properties" \
		--pkg_args "-mp ${WILDFLY_HOME_DIR}/modules org.jboss.as.appclient" \
		-into "${WILDFLY_HOME_DIR}"

	# jboss-cli.sh launcher
	java-pkg_dolauncher \
		jboss-cli.sh \
		--main org.jboss.modules.Main \
		--java_args \
			"\${JAVA_OPTS}
			${java_args}
			-Djboss.cli.config=${WILDFLY_CONF_ROOT}/\${WILDFLY_INSTANCE:=${DEFAULT_INSTANCE_NAME}}/jboss-cli.xml
			-Dlogging.configuration=file:${WILDFLY_CONF_ROOT}/\${WILDFLY_INSTANCE:=${DEFAULT_INSTANCE_NAME}}/jboss-cli-logging.properties" \
		--pkg_args "-mp ${WILDFLY_HOME_DIR}/modules org.jboss.as.cli" \
		-into "${WILDFLY_HOME_DIR}"

	# jdr.sh launcher
	java-pkg_dolauncher \
		jdr.sh \
		--main org.jboss.modules.Main \
		--java_args "\${JAVA_OPTS} ${java_args}" \
		--pkg_args "-mp ${WILDFLY_HOME_DIR}/modules org.jboss.as.jdr" \
		-into "${WILDFLY_HOME_DIR}"

	# vault.sh launcher
	java-pkg_dolauncher \
		vault.sh \
		--main org.jboss.modules.Main \
		--java_args "\${JAVA_OPTS} ${java_args}" \
		--pkg_args "-mp ${WILDFLY_HOME_DIR}/modules org.jboss.as.vault-tool" \
		-into "${WILDFLY_HOME_DIR}"

	# wsconsume.sh launcher
	java-pkg_dolauncher \
		wsconsume.sh \
		--main org.jboss.modules.Main \
		--java_args \
			"\${JAVA_OPTS}
			${java_args}
			-Dprogram.name=wsconsume.sh" \
		--pkg_args \
			"-mp ${WILDFLY_HOME_DIR}/modules org.jboss.ws.tools.wsconsume" \
		-into "${WILDFLY_HOME_DIR}"

	# wsprovide.sh launcher
	java-pkg_dolauncher \
		wsprovide.sh \
		--main org.jboss.modules.Main \
		--java_args \
			"\${JAVA_OPTS}
			${java_args}
			-Dprogram.name=wsprovide.sh" \
		--pkg_args \
			"-mp ${WILDFLY_HOME_DIR}/modules org.jboss.ws.tools.wsprovide" \
		-into "${WILDFLY_HOME_DIR}"


	insinto "${WILDFLY_HOME_DIR}"
	doins -r modules

	insinto "${WILDFLY_HOME_DIR}"
	doins -r welcome-content

	dodoc -r docs/* README.txt

	# Wildfly domain and standalone mode common installation
	local dir
	for dir in domain standalone; do
		# Wildfly needs to create directories and write it's own 
		# configuration files.
		insopts --owner=${WILDFLY_USER} --group=${WILDFLY_GROUP}
		diropts --owner=${WILDFLY_USER} --group=${WILDFLY_GROUP}

		dodir "${WILDFLY_DEFAULT_CONF_DIR}/${dir}"

		insinto "${WILDFLY_DEFAULT_CONF_DIR}/${dir}"
		doins ${dir}/configuration/*
		fperms 660 ${WILDFLY_DEFAULT_CONF_DIR}/${dir}/application-roles.properties \
				   ${WILDFLY_DEFAULT_CONF_DIR}/${dir}/application-users.properties \
				   ${WILDFLY_DEFAULT_CONF_DIR}/${dir}/mgmt-groups.properties \
				   ${WILDFLY_DEFAULT_CONF_DIR}/${dir}/mgmt-users.properties

		dodir ${WILDFLY_DEFAULT_BASE_DIR}/${dir}/lib/ext

		dodir ${WILDFLY_DEFAULT_BASE_DIR}/${dir}/data

		dodir "${WILDFLY_DEFAULT_TMP_DIR}/${dir}"
		dodir "${WILDFLY_DEFAULT_TMP_DIR}/${dir}/auth"
		fperms 750 "${WILDFLY_DEFAULT_TMP_DIR}/${dir}/auth"

		dodir "${WILDFLY_DEFAULT_LOG_DIR}/${dir}"
	done


	# Wildfly standalone mode unique directory installation
	dir="standalone"
	
	insinto "${WILDFLY_DEFAULT_BASE_DIR}/${dir}"
	doins -r ${dir}/deployments

	# init script installation
	newconfd "${FILESDIR}/${PN}.confd" ${PN}-${SLOT}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}-${SLOT}

	sed -i -e "s|@SLOT@|${SLOT}|g" "${D}/etc/conf.d/${PN}-${SLOT}" || \
		die "SLOT pattern replacement failed"
}

pkg_postinst() {
	einfo "To access the management console, add a user to the ManagementRealm:"
	einfo "${WILDFLY_HOME_DIR}/bin/add-user.sh"
	einfo ""
	einfo "Afterwards you can access the console at http://localhost:9990"
	einfo ""
	einfo "The configuration is located at:"
	einfo "${WILDFLY_DEFAULT_CONF_DIR}/[domain|standalone]"
}
