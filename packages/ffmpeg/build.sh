TERMUX_PKG_HOMEPAGE=https://ffmpeg.org
TERMUX_PKG_DESCRIPTION="Tools and libraries to manipulate a wide range of multimedia formats and protocols"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.0
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://www.ffmpeg.org/releases/ffmpeg-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=57be87c22d9b49c112b6d24bc67d42508660e6b718b3db89c44e47e289137082
TERMUX_PKG_DEPENDS="freetype, game-music-emu, libaom, libandroid-glob, libass, libbluray, libbz2, libdav1d, libgnutls, libiconv, liblzma, libmp3lame, libopus, librav1e, libsoxr, libsrt, libssh, libtheora, libvorbis, libvpx, libvidstab, libwebp, libx264, libx265, libxml2 (>= 2.11.4-2), libzimg, littlecms, ocl-icd, xvidcore, zlib"
TERMUX_PKG_BUILD_DEPENDS="opencl-headers"
TERMUX_PKG_CONFLICTS="libav"
TERMUX_PKG_BREAKS="ffmpeg-dev"
TERMUX_PKG_REPLACES="ffmpeg-dev"

termux_step_pre_configure() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed. (These variables are also used afterwards.)
	_FFMPEG_SOVER_avutil=58
	_FFMPEG_SOVER_avcodec=60
	_FFMPEG_SOVER_avformat=60

	local f
	for f in util codec format; do
		local v=$(sh ffbuild/libversion.sh av${f} \
				libav${f}/version.h libav${f}/version_major.h \
				| sed -En 's/^libav'"${f}"'_VERSION_MAJOR=([0-9]+)$/\1/p')
		if [ ! "${v}" ] || [ "$(eval echo \$_FFMPEG_SOVER_av${f})" != "${v}" ]; then
			termux_error_exit "SOVERSION guard check failed for libav${f}.so."
		fi
	done
}

termux_step_configure() {
	cd $TERMUX_PKG_BUILDDIR

	local _EXTRA_CONFIGURE_FLAGS=""
	if [ $TERMUX_ARCH = "arm" ]; then
		_ARCH="armeabi-v7a"
		_EXTRA_CONFIGURE_FLAGS="--enable-neon"
	elif [ $TERMUX_ARCH = "i686" ]; then
		_ARCH="x86"
		# Specify --disable-asm to prevent text relocations on i686,
		# see https://trac.ffmpeg.org/ticket/4928
		_EXTRA_CONFIGURE_FLAGS="--disable-asm"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		_ARCH="x86_64"
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		_ARCH=$TERMUX_ARCH
		_EXTRA_CONFIGURE_FLAGS="--enable-neon"
	else
		termux_error_exit "Unsupported arch: $TERMUX_ARCH"
	fi

	$TERMUX_PKG_SRCDIR/configure \
		--arch="${_ARCH}" \
		--as="$AS" \
		--cc="$CC" \
		--cxx="$CXX" \
		--nm="$NM" \
		--pkg-config="$PKG_CONFIG" \
		--strip="$STRIP" \
		--cross-prefix="${TERMUX_HOST_PLATFORM}-" \
		--disable-indevs \
		--disable-outdevs \
		--enable-indev=lavfi \
		--disable-static \
		--disable-symver \
		--enable-cross-compile \
		--enable-gnutls \
		--enable-gpl \
		--enable-jni \
		--enable-lcms2 \
		--enable-libaom \
		--enable-libass \
		--enable-libbluray \
		--enable-libdav1d \
		--enable-libfreetype \
		--enable-libgme \
		--enable-libmp3lame \
		--enable-libopus \
		--enable-librav1e \
		--enable-libsoxr \
		--enable-libsrt \
		--enable-libssh \
		--enable-libtheora \
		--enable-libvidstab \
		--enable-libvorbis \
		--enable-libvpx \
		--enable-libwebp \
		--enable-libx264 \
		--enable-libx265 \
		--enable-libxml2 \
		--enable-libxvid \
		--enable-libzimg \
		--enable-mediacodec \
		--enable-opencl \
		--enable-shared \
		--prefix="$TERMUX_PREFIX" \
		--target-os=android \
		--extra-libs="-landroid-glob" \
		--disable-vulkan \
		$_EXTRA_CONFIGURE_FLAGS \
		--disable-libfdk-aac
	# GPLed FFmpeg binaries linked against fdk-aac are not redistributable.
}

termux_step_post_massage() {
	cd ${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/lib || exit 1
	local f
	for f in util codec format; do
		local s=$(eval echo \$_FFMPEG_SOVER_av${f})
		if [ ! "${s}" ]; then
			termux_error_exit "Empty SOVERSION for libav${f}."
		fi
		# SOVERSION suffix is expected by some programs, e.g. Firefox.
		if [ ! -e "./libav${f}.so.${s}" ]; then
			ln -sf libav${f}.so libav${f}.so.${s}
		fi
	done
}
