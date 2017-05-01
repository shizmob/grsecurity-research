#!/bin/sh
set -e
. scripts/common.sh

printf "split hunks: "
find split -type f -name '*.patch' -and -not -name 'xx-*.patch' -exec grep -ch '^@@' {} + | awk '{ n += $1 } END { print n }'

printf "remaining hunks: "
grep -crh '^@@' split/xx-grsecurity-$grsecver-$kernver-$grsecdate.patch

printf "original hunks: "
grep -crh '^@@' grsecurity-$grsecver-$kernver-$grsecdate.patch
