# Copyright 1999-2010 Mat
# Distributed under the terms of the GNU General Public License v2
# $Header: 

EAPI="2"

inherit git autotools 

DESCRIPTION="dbus-c++ attempts to provide a C++ API for D-BUS."
HOMEPAGE="http://www.freedesktop.org/wiki/Software/dbus-c++"

EGIT_REPO_URI="git://gitorious.org/dbus-cplusplus/mainline.git"
EGIT_BOOTSTRAP="./autogen.sh"
#EGIT_COMMIT=""
#EGIT_PATCHES="${FILESDIR}/fix_deadlock.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

# probably needs more/less crap listed here ...
RDEPEND="sys-apps/dbus"
DEPEND="${RDEPEND}
	dev-vcs/git
	dev-util/pkgconfig"

src_compile() {
	econf $(use_enable debug ) || die
	emake -j1 || die "emake failed"
}
