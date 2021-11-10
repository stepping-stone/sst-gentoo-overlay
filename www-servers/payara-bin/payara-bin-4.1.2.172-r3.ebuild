# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils user

DESCRIPTION="Payara Server is a drop in replacement for GlassFish Server Open Source Edition, with the peace of mind of quarterly releases containing enhancements, bug fixes and patches."
HOMEPAGE="https://www.payara.fish/"
LICENSE="cddl"
SRC_URI="https://s3-eu-west-1.amazonaws.com/payara.fish/Payara+Downloads/Payara+${PV}/payara-${PV}.zip"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="-external-config"

RDEPEND=">=virtual/jdk-1.8 virtual/jdbc-postgresql-bin"

S="${WORKDIR}"/payara41
INSTALL_DIR=/opt/payara

pkg_setup() {
	enewgroup glassfish
	enewuser glassfish -1 /bin/bash /home/glassfish glassfish
}

src_prepare() {
	find . \( -name \*.bat -or -name \*.exe \) -delete
}

src_prepare() {
	if use external-config ; then
		config_files=(admin-keyfile cacerts.jks domain-passwords domain.xml
			keyfile keystore.jks logging.properties)

		for filename in ${config_files[@]} ; do
			rm glassfish/domains/domain1/config/"${filename}" || die
		done

		rm glassfish/lib/registration/servicetag-registry.xml || die
	fi
}

src_install() {
	insinto "${INSTALL_DIR}"

	doins -r glassfish javadb mq bin
	keepdir "${INSTALL_DIR}"/home

	for filename in bin/* ; do
		fperms 755 "${INSTALL_DIR}"/"${filename}"
		make_wrapper "$(basename "${filename}")" "${INSTALL_DIR}"/"${filename}"
	done

	for filename in glassfish/bin/* ; do
		fperms 755 "${INSTALL_DIR}"/"${filename}"
	done
		# TODO - major version function
	newconfd "${FILESDIR}"/conf glassfishv3
    newinitd "${FILESDIR}"/init glassfishv3


	keepdir "${INSTALL_DIR}"/glassfish/domains
	fperms -R g+w "${INSTALL_DIR}"/glassfish/domains

	fowners -R glassfish:glassfish "${INSTALL_DIR}"

	echo "CONFIG_PROTECT=\"${INSTALL_DIR}/glassfish/config\"" > "${T}"/25payara
	doenvd "${T}"/25payara
}

pkg_postinst() {
	elog "You must be in the glassfish group to use Payara without root rights."
	elog "You should create separate domain for development needs using"
	elog "    \$ asadmin create-domain devdomain"
	elog "under your account"
	elog "Don't use same domain under different credentials!"
}
