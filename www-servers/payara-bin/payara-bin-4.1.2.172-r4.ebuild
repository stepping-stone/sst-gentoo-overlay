# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils user versionator

DESCRIPTION="Payara Server is a drop in replacement for GlassFish Server Open Source Edition, with the peace of mind of quarterly releases containing enhancements, bug fixes and patches."
HOMEPAGE="https://www.payara.fish/"
LICENSE="cddl"
SRC_URI="https://s3-eu-west-1.amazonaws.com/payara.fish/Payara+Downloads/Payara+${PV}/payara-${PV}.zip"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="-external-config"

RDEPEND=">=virtual/jdk-1.8
         virtual/jdbc-postgresql-bin"

S="${WORKDIR}"/payara"$(replace_all_version_separators '' $(get_version_component_range 1-2))"

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

OPT_DIR=/opt/payara
VAR_DIR=/var/opt/payara

src_install() {
	for dir in glassfish/* ; do
		case "${dir}" in
		*/domains)	insinto "${VAR_DIR}" ;;
		*)			insinto "${OPT_DIR}"/glassfish ;;
		esac
		doins -r "${dir}"
	done

	insinto "${OPT_DIR}"
	doins -r javadb mq bin

	for filename in bin/* ; do
		fperms 755 "${OPT_DIR}"/"${filename}"
		make_wrapper "$(basename "${filename}")" "${OPT_DIR}"/"${filename}"
	done

	for filename in glassfish/bin/* ; do
		fperms 755 "${OPT_DIR}"/"${filename}"
	done

	# TODO - major version function
	newconfd "${FILESDIR}"/conf glassfishv3
    newinitd "${FILESDIR}"/init glassfishv3

	dosym "${VAR_DIR}"/domains "${OPT_DIR}"/glassfish/domains

	fperms -R g+w "${VAR_DIR}"/domains
	fowners -R glassfish:glassfish "${OPT_DIR}" "${VAR_DIR}"

	echo "CONFIG_PROTECT=\"${OPT_DIR}/glassfish/config\"" > "${T}"/25payara
	doenvd "${T}"/25payara
}

pkg_postinst() {
	elog "You must be in the glassfish group to use Payara without root rights."
	elog "You should create separate domain for development needs using"
	elog "    \$ asadmin create-domain devdomain"
	elog "under your account"
	elog "Don't use same domain under different credentials!"
}
