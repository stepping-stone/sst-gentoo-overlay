# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Encrypted mysqldump script with compression, logging, blacklisting and Nagios/Icinga monitoring integration"
HOMEPAGE="https://mysqldump-secure.org/"
SRC_URI="https://github.com/cytopia/mysqldump-secure/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl
        app-admin/tmpwatch"
RDEPEND="${DEPEND}"

src_configure() {
	sed -i \
		-e "s|ETCDIR=.*|ETCDIR=${D}/etc|" \
		-e "s|BINDIR=.*|BINDIR=${D}/usr/bin|" \
		-e "s|MANDIR=.*|MANDIR=${D}/usr/share/man|" \
		configure || die

	./configure || die
}
