# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit php-pear-r2

DESCRIPTION="Element for HTML_QuickForm to enable a suggest search."

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-php/PEAR-HTML_QuickForm-3.2.4
    >=dev-php/PEAR-HTML_AJAX-0.4.1"
