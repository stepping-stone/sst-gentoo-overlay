# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5


DESCRIPTION="Leiningen is a build utility for clojure projects."
HOMEPAGE="http://github.com/technomancy/leiningen/"
SRC_URI="https://raw.githubusercontent.com/technomancy/leiningen/${PV}/bin/lein
https://github.com/technomancy/leiningen/releases/download/${PV}/leiningen-${PV}-standalone.jar"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=virtual/jre-1.6.0"
DEPEND=">=virtual/jdk-1.6.0"

MY_P="${PN}${SLOT}-${PV}"

SITEFILE="70${PN}-gentoo.el"

S=${WORKDIR}/${MY_P}

src_unpack() {
        mkdir ${S}
        for f in ${A}; do
            cp /usr/portage/distfiles/${f} ${S}
        done
}

src_install() {
        insinto /usr/bin
        dobin lein
        mkdir -p ${D}/usr/share/java
        cp leiningen-${PV}-standalone.jar ${D}/usr/share/java/leiningen-${PV}-standalone.jar
}
