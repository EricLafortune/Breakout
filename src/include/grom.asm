* Breakout - action game for the TI-99/4A home computer.
*
* Copyright (c) 2021-2022 Eric Lafortune
*
* This program is free software; you can redistribute it and/or modify it
* under the terms of the GNU General Public License as published by the Free
* Software Foundation; either version 2 of the License, or (at your option)
* any later version.
*
* This program is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
* FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
* more details.
*
* You should have received a copy of the GNU General Public License along
* with this program; if not, write to the Free Software Foundation, Inc.,
* 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

******************************************************************************
* Definitions and macros for accessing GROM and GRAM.
******************************************************************************

* GROM addresses.
grmwa equ  >9c02
grmra equ  >9802
grmrd equ  >9800
grmwd equ  >9c00

* Macro: write the given GROM address.
* IN #1: the register containing the the GROM address.
    .defm grmwa
    movb #1, @grmwa
    swpb #1
    movb #1, @grmwa
    swpb #1
    .endm

* Macro: read a word (MSB first) from the current GROM address.
* OUT #1: the register in which to store the read word.
    .defm grmrd
    movb @grmrd, #1
    swpb #1
    movb @grmrd, #1
    swpb #1
    .endm
