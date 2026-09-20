#!/bin/bash
# Compile redux and write dist/thermal-camera-redux_*.deb inside Docker.
set -eu
ROOT="$(cd "$(dirname "$0")" && pwd)"
IMAGE_NAME="${IMAGE_NAME:-thermal-camera-redux-build:latest}"
mkdir -p "${ROOT}/dist"

if ! docker image inspect "${IMAGE_NAME}" >/dev/null 2>&1; then
  echo "Image ${IMAGE_NAME} missing; run ./dockerbuild.sh first."
  exit 1
fi

docker run --rm \
  --user "$(id -u):$(id -g)" \
  -e HOME=/tmp \
  -v "${ROOT}:/work" \
  -w /work \
  "${IMAGE_NAME}" \
  /bin/bash /work/scripts/build_deb_in_container.sh

echo "Build outputs:"
ls -l "${ROOT}/dist"
