# Copyright 2017 stepping stone GmbH
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Virtual for JDBC Driver for PostgreSQL"
KEYWORDS="amd64 ppc64 x86"
SLOT="42.1"

IUSE="java7 java8"
REQUIRED_USE="^^ ( java7 java8 )"

RDEPEND="java7? ( =dev-java/jdbc-postgresql-java7-bin-${PV} )
         java8? ( =dev-java/jdbc-postgresql-java8-bin-${PV} )"

