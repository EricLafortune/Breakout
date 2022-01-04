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
* Definitions and macros for the available colors.
******************************************************************************

transparent  equ  0
black        equ  1
green        equ  2
light_green  equ  3
blue         equ  4
light_blue   equ  5
dark_red     equ  6
cyan         equ  7
red          equ  8
light_red    equ  9
dark_yellow  equ 10
light_yellow equ 11
dark_green   equ 12
magenta      equ 13
gray         equ 14
white        equ 15

* Macro: append a byte with the given colors.
* IN #1: the foreground color.
* IN #2: the background  color.
    .defm color
    byte #1 * 16 + #2
    .endm
