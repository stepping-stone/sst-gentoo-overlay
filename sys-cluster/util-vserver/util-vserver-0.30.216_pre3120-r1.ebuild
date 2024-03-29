# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils bash-completion-r1

MY_P="${P/_/-}"
MY_P="${MY_P%%_rc*}"

DESCRIPTION="Linux-VServer admin utilities"
HOMEPAGE="http://www.nongnu.org/util-vserver/"
SRC_URI="http://people.linux-vserver.org/~dhozac/t/uv-testing/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~sparc x86"

CDEPEND="
    sys-devel/gcc[-hardened]
	dev-libs/beecrypt
	net-firewall/iptables
	net-misc/vconfig
	sys-apps/iproute2"

DEPEND="
	${CDEPEND}
	>dev-libs/dietlibc-0.33"

RDEPEND="
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if [[ -z "${VDIRBASE}" ]]; then
		einfo
		einfo "You can change the default vserver base directory (/vservers)"
		einfo "by setting the VDIRBASE environment variable."
	fi

	: ${VDIRBASE:=/vservers}

	einfo
	einfo "Using \"${VDIRBASE}\" as vserver base directory"
	einfo
}

src_test() {
	# do not use $D from portage by accident (#297982)
	sed -i -e 's/^\$D //' "${S}"/src/testsuite/vunify-test.sh || die

	default
}

src_configure() {
	local myeconf=(
		--with-vrootdir="${VDIRBASE}"
		--with-initscripts=gentoo
		--localstatedir=/var
	)

	econf "${myeconf[@]}"
}

src_compile() {
	emake -j1 || die "emake failed!"
}

src_install() {
	make DESTDIR="${D}" install install-distribution \
		|| die "make install failed!"

	# keep dirs
	keepdir /var/cache/vservers
	keepdir "${VDIRBASE}"
	keepdir "${VDIRBASE}"/.pkg

	# bash-completion
	newbashcomp "${FILESDIR}"/bash_completion ${PN}

	dodoc README ChangeLog NEWS AUTHORS THANKS util-vserver.spec
}

pkg_postinst() {
	# Create VDIRBASE in postinst, so it is (a) not unmerged and (b) also
	# present when merging.

	mkdir -p "${VDIRBASE}" || die
	if ! setattr --barrier "${VDIRBASE}"; then
		ewarn "Filesystem on ${VDIRBASE} does not support chroot barriers."
		ewarn "Chroot barrier is additional security measure that is used"
		ewarn "when two vservers or the host system share the same filesystem."
		ewarn "If you intend to use separate filesystem for every vserver"
		ewarn "you can safely ignore this warning."
		ewarn "To manually apply a barrier use: setattr --barrier ${VDIRBASE}"
		ewarn "For details see: http://linux-vserver.org/Secure_chroot_Barrier"
	fi

	rm /etc/vservers/.defaults/vdirbase || die
	ln -sf "${VDIRBASE}" /etc/vservers/.defaults/vdirbase || die

	elog
	elog "You have to run the vprocunhide command after every reboot"
	elog "in order to setup /proc permissions correctly for vserver"
	elog "use. An init script has been installed by this package."
	elog "To use it you should add it to a runlevel:"
	elog
	elog " rc-update add vprocunhide default"
	elog
}
