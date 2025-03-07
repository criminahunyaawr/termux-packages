TERMUX_PKG_HOMEPAGE=https://gdal.org
TERMUX_PKG_DESCRIPTION="A translator library for raster and vector geospatial data formats"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.TXT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.7.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://download.osgeo.org/gdal/${TERMUX_PKG_VERSION}/gdal-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=af4b26a6b6b3509ae9ccf1fcc5104f7fe015ef2110f5ba13220816398365adce
TERMUX_PKG_DEPENDS="giflib, json-c, libc++, libcurl, libexpat, libfreexl, libgeos, libiconv, libjpeg-turbo, libjxl, liblzma, libpng, libspatialite, libsqlite, libwebp, libxml2 (>= 2.11.4-2), netcdf-c, openjpeg, openssl, proj, postgresql, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="json-c-static"
TERMUX_PKG_BREAKS="gdal-dev"
TERMUX_PKG_REPLACES="gdal-dev"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DGDAL_USE_JXL=ON
-DGDAL_USE_TIFF_INTERNAL=ON
-DGDAL_USE_GEOTIFF_INTERNAL=ON
"
