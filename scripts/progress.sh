#!/bin/sh
set -e
. scripts/common.sh

split=$(find split -type f -name '*.patch' -and -not -name 'xx-*.patch' -exec grep -ch '^@@' {} + | awk '{ n += $1 } END { print n }')
remaining=$(grep -crh '^@@' split/xx-grsecurity-$grsecver-$kernver-$grsecdate.patch)
total=$(grep -crh '^@@' grsecurity-$grsecver-$kernver-$grsecdate.patch)
percentage=$(awk "BEGIN { print ($split * 100) / $total; }")

printf "split hunks: %d (%.2g%%)\n" "$split" "$percentage"
printf "remaining hunks: %d\n" "$remaining"
printf "total hunks: %d\n" "$total"
