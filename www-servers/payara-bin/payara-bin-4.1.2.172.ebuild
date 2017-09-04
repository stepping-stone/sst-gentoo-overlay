# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils user

DESCRIPTION="Payara Server is a drop in replacement for GlassFish Server Open Source Edition, with the peace of mind of quarterly releases containing enhancements, bug fixes and patches."
HOMEPAGE="https://www.payara.fish/"
LICENSE="cddl"
SRC_URI="https://s3-eu-west-1.amazonaws.com/payara.fish/Payara+Downloads/Payara+${PV}/payara-${PV}.zip"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=">=virtual/jdk-1.7 virtual/jdbc-postgresql-bin"

S="${WORKDIR}/payara41"
MY_PN="payara"
INSTALL_DIR="/opt/${MY_PN}"

pkg_setup() {
	enewgroup payara
	enewuser payara -1 /bin/bash ${INSTALL_DIR}/home payara
}

src_prepare() {
	find . \( -name \*.bat -or -name \*.exe \) -delete
}

src_install() {
	insinto ${INSTALL_DIR}

	doins -r glassfish javadb mq bin
	keepdir ${INSTALL_DIR}/home

	for i in bin/* ; do
		fperms 755 ${INSTALL_DIR}/${i}
		make_wrapper "$(basename ${i})" "${INSTALL_DIR}/${i}"
	done

	for i in glassfish/bin/* ; do
		fperms 755 ${INSTALL_DIR}/${i}
	done
		# TODO - major version function
	newconfd "${FILESDIR}"/conf payara
    newinitd "${FILESDIR}"/init payara


	keepdir ${INSTALL_DIR}/glassfish/domains
	fperms -R g+w "${INSTALL_DIR}/glassfish/domains"

	fowners -R payara:payara ${INSTALL_DIR}

	echo "CONFIG_PROTECT=\"${INSTALL_DIR}/glassfish/config\"" > "${T}/25payara"
	doenvd "${T}/25payara"
}

pkg_postinst() {
	elog "You must be in the payara group to use Payara without root rights."
	elog "You should create separate domain for development needs using"
	elog "    \$ asadmin create-domain devdomain"
	elog "under your account"
	elog "Don't use same domain under different credentials!"
}
