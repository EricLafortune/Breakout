#!/bin/sh
#
# This script assembles the sandbox escape code in a TI BASIC program and
# copies it to a floppy disk image.

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
  -a out/breakout.prg
