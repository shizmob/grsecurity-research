#!/bin/sh
printf "split hunks: "
grep -crh '^@@' $(find . -type d -and -not -name '.*' -maxdepth 1) | awk '{ n += $1 } END { print n }'
printf "remaining hunks: "
grep -crh '^@@' grsecurity-*.patch
printf "original hunks: "
grep -crh '^@@' orig-*.patch
