# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 user versionator

DESCRIPTION="Open Source ERP & CRM"
HOMEPAGE="http://www.openerp.com/"

if [[ ${PV} = *99999999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/odoo/odoo.git"
	EGIT_BRANCH="$(get_version_component_range 1-2)"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/odoo/odoo/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+postgres ldap ssl"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CDEPEND="!app-office/openerp-web
	dev-python/pychart[${PYTHON_USEDEP}]
	>=dev-python/Babel-1.0[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/feedparser[${PYTHON_USEDEP}]
	dev-python/gdata[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/passlib[${PYTHON_USEDEP}]
	virtual/python-imaging[jpeg,${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/psycopg:2[${PYTHON_USEDEP}]
	media-gfx/pydot[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	ldap? ( dev-python/python-ldap[${PYTHON_USEDEP}] )
	dev-python/python-openid[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/reportlab[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/vatnumber[${PYTHON_USEDEP}]
	dev-python/vobject[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	dev-python/xlwt[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/pyPdf[${PYTHON_USEDEP}]
	${PYTHON_DEPS}
	postgres? ( dev-db/postgresql[server] )
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
	"

# Additional optional deps:
# gevent? ( dev-python/gevent[${PYTHON_USEDEP}] dev-python/psycogreen[${PYTHON_USEDEP}] )
# esc-pos? ( >=dev-python/pyusb-1.0.0_beta1[${PYTHON_USEDEP}] dev-python/qrcode[${PYTHON_USEDEP}] )
# weighting-scale? ( dev-python/pyserial[${PYTHON_USEDEP}] )

# Listed in docs or setup.py, but otherwise unused dependencies:
# <dev-python/pyparsing-2[${PYTHON_USEDEP}]

RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

OPENERP_USER="openerp"
OPENERP_GROUP="openerp"

# Maintainer note:
# openerp/odoo 8.0 has a broken setup.py which installs only a small part of what is actually needed
src_install() {
	# basic stuff goes into site-packages
	python_domodule openerp

	# the rest in a custom directory using cp to speed up the installation
	dodir /usr/share/openerp
	cp -R addons "${D}/usr/share/openerp/"

	python_doscript openerp-{gevent,server}

	# ... but still optimize python files located there
	python_optimize "${D}/usr/share/openerp/addons"

	dodoc -r *.md doc/*.rst doc/{modules,reference}

	newinitd "${FILESDIR}/${PN}-2" "${PN}"
	newconfd "${FILESDIR}/openerp-confd-2" "${PN}"
	keepdir /var/log/openerp

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/openerp.logrotate openerp
	dodir /etc/openerp
	insinto /etc/openerp
	newins "${FILESDIR}"/openerp.cfg.2 openerp.cfg
}

pkg_preinst() {
	enewgroup ${OPENERP_GROUP}
	enewuser ${OPENERP_USER} -1 -1 -1 ${OPENERP_GROUP}

	fowners -R ${OPENERP_USER}:${OPENERP_GROUP} /etc/openerp
	fowners ${OPENERP_USER}:${OPENERP_GROUP} /var/log/openerp

	fperms 0640 /etc/openerp/openerp.cfg
	fperms 0750 /var/log/openerp

	use postgres || sed -i '6,8d' "${D}/etc/init.d/openerp" || die "sed failed"
}

pkg_postinst() {
	chown -R ${OPENERP_USER}:${OPENERP_GROUP} /etc/openerp
	chown ${OPENERP_USER}:${OPENERP_GROUP} /var/log/openerp

	elog "In order to setup the initial database, run:"
	elog "  emerge --config =${CATEGORY}/${PF}"
	elog "Be sure the database is started before"
}

psqlquery() {
	psql -q -At -U postgres -d template1 -c "$@"
}

pkg_config() {
	einfo "In the following, the 'postgres' user will be used."
	if ! psqlquery "SELECT usename FROM pg_user WHERE usename = '${OPENERP_USER}'" | grep -q ${OPENERP_USER}; then
		ebegin "Creating database user ${OPENERP_USER}"
		createuser --username=postgres --createdb --no-adduser ${OPENERP_USER}
		eend $? || die "Failed to create database user"
	fi
}
