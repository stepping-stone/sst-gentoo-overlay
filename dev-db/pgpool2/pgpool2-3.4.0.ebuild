# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MY_P="${PN/2/-II}-${PV}"

inherit autotools-utils user versionator

DESCRIPTION="Connection pool server for PostgreSQL"
HOMEPAGE="http://www.pgpool.net/"
SRC_URI="http://www.pgpool.net/download.php?f=${MY_P}.tar.gz -> ${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="memcached pam ssl static-libs"

RDEPEND="virtual/postgresql
	memcached? ( dev-libs/libmemcached )
	pam? ( sys-auth/pambase )
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	sys-devel/bison
	!!dev-db/pgpool"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/pgpool_run_paths-$(get_version_component_range 1-2).patch" )
HTML_DOCS=( doc/ )
DOCS=( NEWS TODO doc/where_to_send_queries.{pdf,odg} )

pkg_setup() {
	enewgroup postgres 70
	enewuser pgpool -1 -1 -1 postgres

	# We need the postgres user as well so we can set the proper
	# permissions on the sockets without getting into fights with
	# PostgreSQL's initialization scripts.
	enewuser postgres 70 /bin/bash /var/lib/postgresql postgres
}

src_prepare() {
	autotools-utils_src_prepare

	local pg_config_manual="$(pg_config --includedir)/pg_config_manual.h"
	local pgsql_socket_dir=$(grep DEFAULT_PGSOCKET_DIR "${pg_config_manual}" | \
		sed 's|.*\"\(.*\)\"|\1|g')
	local pgpool_socket_dir="$(dirname $pgsql_socket_dir)/pgpool"

	sed "s|@PGSQL_SOCKETDIR@|${pgsql_socket_dir}|g" \
		-i src/sample/*.conf.sample* src/include/pool.h || die

	sed "s|@PGPOOL_SOCKETDIR@|${pgpool_socket_dir}|g" \
		-i src/sample/*.conf.sample* src/include/pool.h || die
}

src_configure() {
	local myeconfargs=(
		--disable-rpath \
		--sysconfdir="${EROOT%/}/etc/${PN}" \
		$(use_with ssl openssl) \
		$(use_enable static-libs static) \
	)

	use memcached && myeconfargs+=("--with-memcached=\"${EROOT%/}/usr/include/libmemcached\"")
	use pam && myconf+=('--with-pam')

	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	autotools-utils_src_compile -C src/sql
}

src_install() {
	autotools-utils_src_install
	autotools-utils_src_install -C src/sql 

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}

	# Examples and extras
	insinto "/usr/share/${PN}"
	doins doc/{pgpool_remote_start,basebackup.sh,recovery.conf.sample}
	mv "${ED%/}/usr/share/${PN/2/-II}" "${ED%/}/usr/share/${PN}" || die
}
