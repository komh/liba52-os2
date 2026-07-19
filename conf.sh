#! /bin/sh

d="$(dirname "$0")"

target=i686-pc-os2-emx

export CFLAGS="-g -O2 -std=c99"
export LDFLAGS=-Zhigh-mem

opts="
    --prefix=/@unixroot/usr/local
    --disable-shared
    --enable-static
"

if [ -n "$1" ] && [ "${1#-}" = "$1" ]; then
    # $1 is a build dir
    [ -f "$1/configure" ] \
        && { echo "BUILD dir should be different from SOURCE dir!!!"; exit 1; }

    blddir="$1"
    shift
else
    # $1 is empty or an option. Determine the build dir with configure
    [ -f configure ] && blddir=build || blddir=.
fi

srcdir=$(cd "$d"; pwd)  # get absolute path of configure
srcdir=${srcdir#*:}     # remove drive letter
[ -f "$srcdir/configure" ] \
    || { echo "\`$srcdir/configure' not found!!!"; exit 1; }

[ -z "$OS2_SHELL" ] && opts="$opts --host=$target"

mkdir -p "$blddir" && cd "$blddir" || exit 1

eval '"$srcdir/configure"' $opts '"$@"'
