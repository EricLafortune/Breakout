#!/bin/sh
#
# This script launches Mame with the TI-99/$A, the floppy drive,
# and a floppy disk mounted.

exec mame ti99_4a \
  -ioport peb \
  -ioport:peb:slot8 tifdc \
  -flop1 out/breakout.dsk \
  "$@"
