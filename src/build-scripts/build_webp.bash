#!/usr/bin/env bash

# Utility script to download and build webp
#
# Copyright Contributors to the OpenImageIO project.
# SPDX-License-Identifier: BSD-3-Clause
# https://github.com/OpenImageIO/oiio

# Exit the whole script if any command fails.
set -ex

# Repo and branch/tag/commit of webp to download if we don't have it yet
WEBP_REPO=${WEBP_REPO:=https://github.com/webmproject/libwebp.git}
WEBP_VERSION=${WEBP_VERSION:=v1.1.0}

# Where to put webp repo source (default to the ext area)
WEBP_SRC_DIR=${WEBP_SRC_DIR:=${PWD}/ext/webp}
# Temp build area (default to a build/ subdir under source)
WEBP_BUILD_DIR=${WEBP_BUILD_DIR:=${WEBP_SRC_DIR}/build}
# Install area for webp (default to ext/dist)
WEBP_INSTALL_DIR=${WEBP_INSTALL_DIR:=${PWD}/ext/dist}
#WEBP_CONFIG_OPTS=${WEBP_CONFIG_OPTS:=}

pwd
echo "webp install dir will be: ${WEBP_INSTALL_DIR}"

mkdir -p ./ext
pushd ./ext

# Clone webp project from GitHub and build
if [[ ! -e ${WEBP_SRC_DIR} ]] ; then
    echo "git clone ${WEBP_REPO} ${WEBP_SRC_DIR}"
    git clone ${WEBP_REPO} ${WEBP_SRC_DIR}
fi
cd ${WEBP_SRC_DIR}
echo "git checkout ${WEBP_VERSION} --force"
git checkout ${WEBP_VERSION} --force

mkdir -p ${WEBP_BUILD_DIR}
cd ${WEBP_BUILD_DIR}
time cmake --config Release \
           -DCMAKE_BUILD_TYPE=Release \
           -DCMAKE_INSTALL_PREFIX=${WEBP_INSTALL_DIR} \
           -DWEBP_BUILD_ANIM_UTILS=OFF \
           -DWEBP_BUILD_CWEBP=OFF \
           -DWEBP_BUILD_DWEBP=OFF \
           -DWEBP_BUILD_VWEBP=OFF \
           -DWEBP_BUILD_GIF2WEBPx=OFF \
           -DWEBP_BUILD_IMG2WEBP=OFF \
           -DWEBP_BUILD_EXTRAS=OFF \
           ${WEBP_CONFIG_OPTS} ..
time cmake --build . --config Release --target install



ls -R ${WEBP_INSTALL_DIR}
popd


# Set up paths. These will only affect the caller if this script is
# run with 'source' rather than in a separate shell.
export Webp_ROOT=$WEBP_INSTALL_DIR

