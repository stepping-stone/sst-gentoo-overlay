# Copyright 1999-2015 stepping stone GmbH, Switzerland
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit php-pear-r2

DESCRIPTION="Visualization of GIS data"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="amd64"

DEPEND="dev-lang/php:*[gd]
	dev-php/PEAR-Cache_Lite
	dev-php/PEAR-Image_Color
	dev-php/PEAR-XML_SVG"
RDEPEND="${DEPEND}"
