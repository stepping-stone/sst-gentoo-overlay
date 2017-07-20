# Copyright 2017 stepping stone GmbH
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit eutils

MY_PV="${PV}.jre7"

DESCRIPTION="JDBC Driver for PostgreSQL for JAVA 1.7"
SRC_URI="http://jdbc.postgresql.org/download/postgresql-${MY_PV}.jar"
HOMEPAGE="http://jdbc.postgresql.org/"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

DEPEND="virtual/jre:1.7"
RDEPEND="${DEPEND}"

src_unpack() {
	mkdir ${S}
	cp ${DISTDIR}/${A} ${S}/
}

src_install() {
    dodir /usr/share/jdbc-postgresql/lib
	insinto /usr/share/jdbc-postgresql/lib
    doins ${A}
    dosym ${A} /usr/share/jdbc-postgresql/lib/jdbc-postgresql.jar
}
