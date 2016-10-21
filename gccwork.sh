FILENAME=content/project/gccwork.md
cat  > $FILENAME <<HEADER
---
title: "GCC commits and patches"
tags: ["toolchain", "gcc", "binutils", "avr"]
date: "$(date)"
summary: "My GCC commits and patches"
categories: ["software", "toolchain"]
---
HEADER
echo "# Recent GCC commits" >> $FILENAME
curl "https://gcc.gnu.org/git/?p=gcc.git&a=search&h=HEAD&st=committer&s=saaadhu" | pup 'td a[class="list subject"] json{}' | jq 'map(@html "[\(.text)](https://gcc.gnu.org\(.href))")' | tail -n +2 | head -n -2 | sed -e 's/"//g' | sed -e 's/,$//g' | sed -e 'G;' >> $FILENAME 
echo "# GCC Patches" >> $FILENAME
curl "https://patchwork.ozlabs.org/project/gcc/list/?submitter=15932&order=state" | pup 'table tr td:first-child a json{}'| jq 'map(@html "[\(.text)](http://patchwork.ozlabs.org\(.href))")' | tail -n +2 | head -n -1 | sed -e 's/"//g' | sed -e 's/,$//g' | sed -e 'G;' >> $FILENAME 
