#!/bin/sh
set -e
. scripts/common.sh

context=0
add=0
sub=0

export IFS=
while read -r line ; do
	case "$line" in
	+*) add=$((add+1)) ;;
	-*) sub=$((sub+1)) ;;
	' '*) context=$((context+1)) ;;
	esac
done

echo $(($context + $sub)) $(($context + $add))
