#!/usr/bin/env bash
# Rebuild the bundled legacy API with PIC and the host's OpenSSL.
set -euo pipefail
addon_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
build_root="$(mktemp -d)"
trap 'rm -rf "$build_root"' EXIT
git clone https://github.com/warmcat/libwebsockets.git "$build_root/source"
git -C "$build_root/source" checkout --detach 16fb0132cec0fcced29bce6d86eaf94a9beb9785
cmake -S "$build_root/source" -B "$build_root/build" \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DCMAKE_C_FLAGS=-Wno-error=deprecated-declarations \
    -DLWS_WITHOUT_TESTAPPS=ON
cmake --build "$build_root/build" --target websockets -j2
cp "$build_root/build/lib/libwebsockets.a" \
    "$addon_root/libs/libwebsockets/lib/linux64/libwebsockets.a"
