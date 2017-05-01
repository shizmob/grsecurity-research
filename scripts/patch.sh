#!/bin/sh
set -e
. scripts/common.sh

if ! test -d linux-$kernver ; then
	curl -L https://cdn.kernel.org/pub/linux/kernel/v${kernver%%.*}.x/linux-$kernver.tar.xz | tar -xJ
fi

if test -f linux-$kernver/.applied-remainder.patch ; then
	patch -ts -R -d linux-$kernver < linux-$kernver/.applied-remainder.patch
	rm linux-$kernver/.applied-remainder.patch
fi

find split -name '*.patch' | while read f; do printf "%s:%s\n" "$(basename "$f")" "$f" ; done | sort | cut -d: -f2- | while read patch ; do
	base="$(basename "$patch")"
	test -f linux-$kernver/.applied-"$base" && continue
	echo ">> applying ${patch#split/}..."
	patch -ts -d linux-$kernver -p1 < "$patch" && touch linux-$kernver/.applied-"$base" || exit 1
done

if test -z "$SLIM" ; then
	echo ">> applying remainder..."
	patch -ts -d linux-$kernver -p1 < "grsecurity-$grsecver-$kernver-$grsecdate.patch"
	cp "grsecurity-$grsecver-$kernver-$grsecdate.patch" linux-$kernver/.applied-remainder.patch
fi
