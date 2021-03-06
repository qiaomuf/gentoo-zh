# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/ebuildteam/media-libs/fontconfig/fontconfig-2.2.3-r2.ebuild,v 1.3 2005/03/30 14:50:22 scsi Exp $

inherit eutils

DESCRIPTION="A library for configuring and customizing font access"
HOMEPAGE="http://freedesktop.org/Software/fontconfig"
#SRC_URI="http://pdx.freedesktop.org/software/fontconfig/releases/${P}.tar.gz"
SRC_URI="http://freedesktop.org/~fontconfig/release/${P}.tar.gz"

LICENSE="fontconfig"
SLOT="1.0"
KEYWORDS="x86 ~ppc sparc ~mips alpha arm hppa amd64 ia64 ~ppc64 s390"
IUSE="zh_TW"

RDEPEND=">=media-libs/freetype-2.1.4
	>=dev-libs/expat-1.95.3"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {

	unpack ${A}
	cd ${S}

	if use zh_TW
	then
		einfo "Apply Firefly Patch :)..."
			epatch ${FILESDIR}/2.2.3.firefly/fontconfig-2.2.3-add_extra_option-20041127.patch
			epatch ${FILESDIR}/2.2.3.firefly/fontconfig-2.2.3-alllang-20041114.patch
			epatch ${FILESDIR}/2.2.3.firefly/fontconfig-2.2.3-default_config-20041114.patch
			epatch ${FILESDIR}/2.2.3.firefly/fontconfig-2.2.3-fakestyle-20041117.patch
			epatch ${FILESDIR}/2.2.3.firefly/fontconfig-2.2.3-include_CJK_charmaps-20041114.patch
			epatch ${FILESDIR}/2.2.3.firefly/fontconfig-2.2.3-miss_1_percent-20041128.patch
			epatch ${FILESDIR}/2.2.3.firefly/fontconfig-2.2.3-multifamily-20041117.patch
		einfo
	fi

	local PPREFIX="${FILESDIR}/patch/${PN}"

	# Some patches from Redhat
	#epatch ${PPREFIX}-2.1-slighthint.patch
	# Add our local fontpaths (duh dont forget!)
	#epatch ${PPREFIX}-2.2-local_fontdir-r1.patch
	# Blacklist some fonts that break fontconfig
	epatch ${PPREFIX}-2.2-blacklist.patch
	# Remove the subpixel test from local.conf (#12757)
	epatch ${PPREFIX}-2.2-remove_subpixel_test.patch
	
	# The date can be troublesome
	sed -i "s:\`date\`::" configure

}

src_compile() {

	[ "${ARCH}" == "alpha" -a "${CC}" == "ccc" ] && \
		die "Dont compile fontconfig with ccc, it doesnt work very well"

	# disable docs only disables docs generation (!)
	econf --disable-docs \
		--with-docdir=/usr/share/doc/${PF} \
		--x-includes=/usr/X11R6/include \
		--x-libraries=/usr/X11R6/lib \
		--with-default-fonts=/usr/X11R6/lib/X11/fonts/Type1 || die

	# this triggers sandbox, we do this ourselves
	sed -i "s:fc-cache/fc-cache -f -v:sleep 0:" Makefile

	emake -j1 || die

	# remove Luxi TTF fonts from the list, the Type1 are much better
	sed -i "s:<dir>/usr/X11R6/lib/X11/fonts/TTF</dir>::" fonts.conf

}

src_install() {

	make DESTDIR=${D} install || die

	insinto /etc/fonts
	doins ${S}/fonts.conf
	newins ${S}/fonts.conf fonts.conf.new

	cd ${S}

	newman fc-cache/fc-cache.man fc-cache.1
	newman fc-list/fc-list.man fc-list.1
	newman src/fontconfig.man fontconfig.3
	dodoc AUTHORS ChangeLog NEWS README
}

pkg_postinst() {

	# Changes should be made to /etc/fonts/local.conf, and as we had
	# too much problems with broken fonts.conf, we force update it ...
	# <azarah@gentoo.org> (11 Dec 2002)
	ewarn "Please make fontconfig related changes to /etc/fonts/local.conf,"
	ewarn "and NOT to /etc/fonts/fonts.conf, as it will be replaced!"
	mv -f ${ROOT}/etc/fonts/fonts.conf.new ${ROOT}/etc/fonts/fonts.conf
	rm -f ${ROOT}/etc/fonts/._cfg????_fonts.conf

	if [ "${ROOT}" = "/" ]
	then
		echo
		einfo "Creating font cache..."
		HOME="/root" /usr/bin/fc-cache
	fi

}
