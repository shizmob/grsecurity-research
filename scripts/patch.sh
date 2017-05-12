#!/bin/sh
set -e
. scripts/common.sh

if ! test -d linux-$kernver ; then
	curl -L https://cdn.kernel.org/pub/linux/kernel/v${kernver%%.*}.x/linux-$kernver.tar.xz | tar -xJ
fi

# Undo applied patches.
find linux-$kernver -name '.applied-*.patch' | sort -r | while read patch ; do
	base="$(basename "$patch")"
	echo ">> reverting ${base#.applied-}..."
	patch -stRd linux-$kernver -p1 < "$patch" || exit 1
	rm "$patch"
done

# Apply patches again. Sort by: module (misc/pax/grsec), feature name, patch name.
find split -type f -name '*.patch' | while read f; do printf "%s:%s:%s\n" $(echo "$f" | cut -d/ -f2) "$(basename $(dirname "$f"))" "$f" ; done | sort | while read patch ; do
	section="${patch%%:*}"
	patch="${patch#*:}"
	dir="${patch%%:*}"
	patch="${patch#*:}"

	base="$(basename "$patch")"
	test -f linux-$kernver/.applied-"$section"-"$dir"-"$base" && continue

	echo ">> applying ${patch#split/}..."
	if ! patch -stNd linux-$kernver -p1 < "$patch" ; then
		patch -stRd linux-$kernver -p1 < "$patch"
		exit 1
	fi
	cp "$patch" linux-$kernver/.applied-"$section"-"$dir"-"$base"
done
