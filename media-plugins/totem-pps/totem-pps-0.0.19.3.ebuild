# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools base

DESCRIPTION="PPStream browser for totem"
HOMEPAGE="http://cgit.freedesktop.org/~jinghua/totem-pps"
SRC_URI="http://people.freedesktop.org/~jinghua/distfiles/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RESTRICT="primaryuri"

RDEPEND="
	dev-python/beautifulsoup
	media-plugins/gst-plugins-pps
	media-video/totem[python]"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40.0
	sys-devel/gettext"

src_prepare() {
	eautoreconf
}
