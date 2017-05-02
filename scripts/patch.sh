#!/bin/sh
set -e
. scripts/common.sh

if ! test -d linux-$kernver ; then
	curl -L https://cdn.kernel.org/pub/linux/kernel/v${kernver%%.*}.x/linux-$kernver.tar.xz | tar -xJ
fi

# Undo applied patches.
find linux-$kernver -name '.applied-*.patch' | sort -r | while read patch ; do
	echo ">> reverting $(basename "$patch")..."
	patch -stRd linux-$kernver -p1 < "$patch" || exit 1
	rm "$patch"
done

# Apply patches again.
find split -name '*.patch' | while read f; do printf "%s:%s\n" "$(basename "$f")" "$f" ; done | sort | cut -d: -f2- | while read patch ; do
	base="$(basename "$patch")"
	test -f linux-$kernver/.applied-"$base" && continue

	echo ">> applying ${patch#split/}..."
	if ! patch -stNd linux-$kernver -p1 < "$patch" ; then
		patch -stRd linux-$kernver -p1 < "$patch"
		exit 1
	fi
	cp "$patch" linux-$kernver/.applied-"$base"
done
