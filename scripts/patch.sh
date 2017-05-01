#!/bin/sh
set -e
. scripts/common.sh

if ! test -d linux-$kernver ; then
	curl -L https://cdn.kernel.org/pub/linux/kernel/v${kernver%%.*}.x/linux-$kernver.tar.xz | tar -xJ
fi

find split -name '*.patch' | while read f; do printf "%s:%s\n" "$(basename "$f")" "$f" ; done | sort | cut -d: -f2- | while read patch ; do
	base="$(basename "$patch")"
	test -f linux-$kernver/.applied-"$base" && continue
	echo ">> applying $(basename $(dirname "$patch"))/$base..."
	patch -ts -d linux-$kernver -p1 < "$patch" && touch linux-$kernver/.applied-"$base"
done

if test -n "$FULL" ; then
	echo ">> applying remainder..."
	patch -ts -d linux-$kernver -p1 < "grsecurity-$grsecver-$kernver-$grsecdate.patch"
fi
