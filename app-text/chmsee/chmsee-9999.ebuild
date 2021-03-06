# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils git

EGIT_REPO_URI="git://github.com/lidaobing/chmsee.git"

DESCRIPTION="Gecko-based HTML Help (chm) viewer"
HOMEPAGE="http://chmsee.googlecode.com"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=dev-libs/glib-2.8:2
	dev-libs/libxml2
	>=x11-libs/gtk+-2.16:2
	dev-libs/chmlib
	dev-libs/libgcrypt
	>=net-libs/xulrunner-1.9.2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.37"

DOCS="NEWS README AUTHORS ChangeLog"
