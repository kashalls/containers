#!/usr/bin/env bash
listing=$(curl -s https://download.samba.org/pub/samba/)
version=$(echo "$listing" | grep -oP 'LATEST-IS-SAMBA-[0-9.]+(?=<)' | awk -F- '{print $NF}')
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
