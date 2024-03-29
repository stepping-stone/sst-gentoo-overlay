# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Binary Kernel, based on sys-kernel/gentoo-sources"
HOMEPAGE=""
SRC_URI="https://mirror.stepping-stone.ch/public/gentoo/binary-kernel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="amd64"
IUSE=""

DEPEND="sys-boot/grub:2"
RDEPEND="${DEPEND}"

src_install() {
	doins -r boot lib usr
}

pkg_postinst() {
	grub-mkconfig -o /boot/grub/grub.cfg \
		|| die "unable to generate GRUB configuration file"

	rm -f /boot/{System.map,vmlinuz,config}.old
}
