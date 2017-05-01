#!/bin/sh
set -e
. scripts/common.sh

test ! -d linux-$kernver && scripts/patch.sh
if ! test -d linux-$kernver-grsec ; then
        mkdir linux-$kernver-grsec
	curl -L https://cdn.kernel.org/pub/linux/kernel/v${kernver%%.*}.x/linux-$kernver.tar.xz | tar -xJ -C linux-$kernver-grsec --strip-components 1
        patch -stNd linux-$kernver-grsec -p1 < grsecurity-$grsecver-$kernver-$grsecdate.patch
fi

diff -Nru -x '.applied-*' -x '*.orig' -x '*.rej' linux-$kernver-grsec linux-$kernver
