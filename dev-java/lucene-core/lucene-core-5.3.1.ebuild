# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-ivy:2"

inherit eutils java-pkg-2 java-ant-2
DESCRIPTION="Apache Lucene Core"
HOMEPAGE="http://lucene.apache.org/core/"
SRC_URI="mirror://apache/lucene/java/${PV}/lucene-${PV}-src.tgz"
LICENSE="Apache-2.0"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.7"
RDEPEND=">=virtual/jre-1.7"

S=${WORKDIR}/lucene-${PV}

EANT_BUILD_XML="core/build.xml"
EANT_BUILD_TARGET="jar-core"
EANT_DOC_TARGET="javadocs"

src_install() {
	java-pkg_newjar build/core/lucene-core-${PV}-SNAPSHOT.jar ${PN}.jar

	use source && java-pkg_dosrc core/src/java/org
}
