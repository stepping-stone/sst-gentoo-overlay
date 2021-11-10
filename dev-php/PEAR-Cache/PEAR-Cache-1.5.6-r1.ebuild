# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit php-pear-r2 eutils

DESCRIPTION="Framework for caching of arbitrary data"

LICENSE="PHP-2.02"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE="weaker-perm"

DEPEND=">=dev-php/PEAR-PEAR-1.7.0"
RDEPEND="dev-php/PEAR-HTTP_Request"

src_prepare() {
	use weaker-perm && epatch "${FILESDIR}"/${P}-weaker-perm.patch
}
