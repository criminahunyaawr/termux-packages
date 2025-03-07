TERMUX_PKG_HOMEPAGE=http://www.nongnu.org/oath-toolkit/
TERMUX_PKG_DESCRIPTION="One-time password components"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.7
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://download.savannah.nongnu.org/releases/oath-toolkit/oath-toolkit-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=36eddfce8f2f36347fb257dbf878ba0303a2eaafe24eaa071d5cd302261046a9
TERMUX_PKG_DEPENDS="libxml2 (>= 2.11.4-2), xmlsec"
TERMUX_PKG_BREAKS="oathtool-dev"
TERMUX_PKG_REPLACES="oathtool-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-pam"

termux_step_post_configure() {
	# Fix out-of-tree build
	local _gdoc="./libpskc/man/gdoc"
	if [ ! -e "${_gdoc}" ]; then
		ln -sf "$TERMUX_PKG_SRCDIR/libpskc/man/gdoc" "${_gdoc}"
	fi

	# Avoid overlinking
	sed -i 's/ -shared / -Wl,--as-needed\0/g' ./libpskc/libtool
}
