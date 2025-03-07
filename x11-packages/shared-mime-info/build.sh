TERMUX_PKG_HOMEPAGE=https://freedesktop.org/Software/shared-mime-info
TERMUX_PKG_DESCRIPTION="Freedesktop.org Shared MIME Info"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/${TERMUX_PKG_VERSION}/shared-mime-info-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bcf5d552318136cf7b3ae259975f414fbcdc9ebce000c87cf1f0901ff14e619f
TERMUX_PKG_DEPENDS="coreutils, glib, libxml2 (>= 2.11.4-2)"

termux_step_create_debscripts() {
	cp "${TERMUX_PKG_BUILDER_DIR}/postinst" ./postinst
	cp "${TERMUX_PKG_BUILDER_DIR}/postrm"   ./postrm
	cp "${TERMUX_PKG_BUILDER_DIR}/triggers" ./triggers
	sed -i "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" ./{post{inst,rm},triggers}
}
