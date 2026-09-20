#!/bin/bash
# Build the Debian-sid compile image used by indockerbuild.sh.
set -eu
ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "${ROOT}"
IMAGE_NAME="${IMAGE_NAME:-thermal-camera-redux-build:latest}"
mkdir -p "${ROOT}/dist"
LOG="${ROOT}/dist/dockerbuild_$(date +%Y%m%d_%H%M%S).log"
echo "Building ${IMAGE_NAME}, log: ${LOG}"
docker build -t "${IMAGE_NAME}" -f "${ROOT}/Dockerfile" "${ROOT}" 2>&1 | tee "${LOG}"
echo "Image ${IMAGE_NAME} ready."
