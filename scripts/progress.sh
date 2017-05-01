#!/bin/sh
set -e
. scripts/common.sh

printf "split hunks: "
find split -type f -name '*.patch' -exec grep -ch '^@@' {} + | awk '{ n += $1 } END { print n }'

printf "remaining hunks: "
grep -crh '^@@' grsecurity-$grsecver-$kernver-$grsecdate.patch

printf "original hunks: "
grep -crh '^@@' orig-grsecurity-$grsecver-$kernver-$grsecdate.patch
