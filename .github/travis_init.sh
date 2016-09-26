## vim:set ts=4 sw=4 et:

# Support for Travis CI -- https://travis-ci.org/upx/upx/builds
# Copyright (C) Markus Franz Xaver Johannes Oberhumer

umask 022
cd /; cd "$TRAVIS_BUILD_DIR" || exit 1

if test "X$C" = "X"; then C=gcc; fi
BUILD_DIR="$TRAVIS_BUILD_DIR/build/$C"
mkdir -p "$BUILD_DIR"

if test "X$B" = "X"; then B=release; fi
BUILD_METHOD="$B"

CC=false CXX=false SCAN_BUILD=false
case $C in
    clang | clang-m?? | clang-3.4-m?? | clang-[678][0-9][0-9]-m??)
        # standard system compiler
        CC="clang"; CXX="clang++" ;;
    clang-[34].[0-9]-m??)
        v=${C:6:3}; CC="clang-$v"; CXX="clang++-$v"; SCAN_BUILD="scan-build-$v" ;;
    gcc | gcc-m?? | gcc-4.6-m??)
        # standard system compiler
        CC="gcc"; CXX="g++" ;;
    gcc-[34].[0-9]-m??)
        v=${C:4:3}; CC="gcc-$v"; CXX="g++-$v" ;;
    gcc-[56]-m?? | gcc-[56].[0-9]-m??)
        v=${C:4:1}; CC="gcc-$v"; CXX="g++-$v" ;;
esac
case $C in
    *-m32) CC="$CC -m32"; CXX="$CXX -m32" ;;
    *-m64) CC="$CC -m64"; CXX="$CXX -m64" ;;
esac
case $C in
    clang* | gcc*) CC="$CC -std=gnu89" ;;
esac
export CC CXX

export UPX_UCLDIR="$TRAVIS_BUILD_DIR/deps/ucl-1.03"