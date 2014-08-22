# Copyright 1999-2014 stepping stone GmbH
# Distributed under the terms of the GNU Affero General Public License v3
# $Header: $

EAPI=5

inherit perl-module

DESCRIPTION="stepping stone Online Backup Script"
HOMEPAGE="http://www.stepping-stone.ch/support/online-backup/howto/linux/
	https://github.com/stepping-stone/online-backup"
SRC_URI="https://github.com/stepping-stone/online-backup/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EUPL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/perl
	net-misc/rsync"

S="${WORKDIR}/online-backup-${PV}"

src_configure() {
	sed -i \
		-e 's|/usr/local/scripts/OnlineBackup/conf|/etc/OnlineBackup|g' \
		-e 's|/usr/local/scripts/OnlineBackup/tmp|/var/lib/OnlineBackup|' \
		conf/OnlineBackup.conf.default || die "sed failed"
}

src_install() {
	insinto ${VENDOR_LIB}
	doins bin/*.pm

	dobin bin/*.{pl,sh}

	insinto /etc/OnlineBackup
	doins conf/*

	keepdir /var/lib/OnlineBackup

	dodoc CHANGES doc/*.txt
	dohtml doc/*.html
}
