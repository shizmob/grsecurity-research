#!/bin/sh
set -e
. scripts/common.sh

if ! test -d linux-$kernver ; then
	curl -L https://cdn.kernel.org/pub/linux/kernel/v${kernver%%.*}.x/linux-$kernver.tar.xz | tar -xJ
fi

# Undo applied patches.
find linux-$kernver -name '.applied-*.patch' | sort -r | while read patch ; do
	case "$patch" in */.applied-xx-*) args=-s ;; *) args= ;; esac
	echo ">> reverting $(basename "$patch")..."
	patch $args -t -R -d linux-$kernver -p1 < "$patch" || exit 1
	rm "$patch"
done

# Apply patches again.
find split -name '*.patch' | while read f; do printf "%s:%s\n" "$(basename "$f")" "$f" ; done | sort | cut -d: -f2- | while read patch ; do
	base="$(basename "$patch")"
	test -f linux-$kernver/.applied-"$base" && continue
	case "$base" in xx-*) args=-s ;; *) args= ;; esac

	echo ">> applying ${patch#split/}..."
	patch $args -t -N -d linux-$kernver -p1 < "$patch" || exit 1
	cp "$patch" linux-$kernver/.applied-"$base"
done
