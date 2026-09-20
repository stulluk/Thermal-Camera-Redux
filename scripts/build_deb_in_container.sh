#!/bin/bash
# Runs inside the build container. Compiles redux and writes a .deb into /work/dist.
set -eu

DEST=/work/dist
STAGING=/tmp/redux-pkg
mkdir -p "${DEST}" "${STAGING}"

echo "=== compiler ==="
g++ --version | head -1
pkg-config --modversion opencv4

echo "=== Thermal-Camera-Redux ==="
g++ -Wall -Wextra -O3 -ffast-math \
  -DBORDER_LAYOUT=0 \
  -DDEFAULT_FONT=0 \
  -DDEFAULT_COLORMAP=4 \
  -DROTATION=0 \
  -DDISPLAY_WIDTH=1920 \
  -DDISPLAY_HEIGHT=1080 \
  -DUSE_CELSIUS=1 \
  -DHUD_ALPHA=0.4 \
  -DUSE_ASSERT=0 \
  -I/usr/include/opencv4 \
  /work/src/tc001.cpp \
  /work/src/thread.cpp \
  -o "${DEST}/redux" \
  -lpthread \
  -lopencv_highgui -lopencv_videoio -lopencv_imgcodecs \
  -lopencv_imgproc -lopencv_core

echo "=== package thermal-camera-redux ==="
PKG="${STAGING}/thermal-camera-redux"
rm -rf "${PKG}"
cp -a /work/packaging/thermal-camera-redux "${PKG}"
mkdir -p "${PKG}/usr/libexec/thermal-camera-redux"
cp -f "${DEST}/redux" "${PKG}/usr/libexec/thermal-camera-redux/redux"
chmod 0755 "${PKG}/usr/bin/redux"
chmod 0755 "${PKG}/usr/libexec/thermal-camera-redux/redux"
chmod 0644 "${PKG}/DEBIAN/control"
chmod 0644 "${PKG}/usr/share/applications/thermal-camera-redux.desktop"
find "${PKG}/usr/share/doc" -type f -exec chmod 0644 {} \;
dpkg-deb --root-owner-group --build "${PKG}" \
  "${DEST}/thermal-camera-redux_0.9.3-1_amd64.deb"

echo "=== outputs ==="
ls -l "${DEST}/redux" "${DEST}/thermal-camera-redux_0.9.3-1_amd64.deb"
echo "redux NEEDED:"
objdump -p "${DEST}/redux" | awk '/NEEDED/ { print $2 }'
