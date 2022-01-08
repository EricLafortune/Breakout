#!/bin/sh
#
# This script assembles the source code into a TI BASIC program
# (out/breakout.prg), copies it to a floppy disk image (out/breakout.dsk),
# and also packages it in TIFILES format (out/breakout.tfi).

mkdir -p out \
&& xas99.py \
  --register-symbols \
  --binary \
  src/jailbreak.asm \
  --listing-file out/breakout.lst \
  --output       out/breakout.prg \
&& xdm99.py \
  out/breakout.dsk \
  -X sssd \
  -a out/breakout.prg \
&& xdm99.py \
  -T out/breakout.prg \
  -o out/breakout.tfi
