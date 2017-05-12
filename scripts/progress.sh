#!/bin/sh
set -e
. scripts/common.sh

split=$(find split -type f -name '*.patch' -and -not -name 'unsplit-*' -exec grep -ch '^@@' {} + | awk '{ n += $1 } END { print n }')
remaining=$(grep -crh '^@@' split/*/zz-unsplit/*.patch | awk '{ n += $1 } END { print n }')
total=$(grep -crh '^@@' original/pax-linux-$kernver-$paxver.patch original/grsecurity-nopax-$grsecver-$kernver-$grsecdate.patch | awk '{ n += $1 } END { print n }')
percentage=$(awk "BEGIN { print ($split * 100) / $total; }")

printf "split hunks: %d (%.3g%%)\n" "$split" "$percentage"
printf "remaining hunks: %d\n" "$remaining"
printf "total hunks: %d\n" "$total"
