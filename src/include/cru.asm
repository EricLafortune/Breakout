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
* Definitions and macros for accessing the Communication Register Unit (CRU).
*
* The CRU address space is documented in
*     https://www.unige.ch/medecine/nouspikel/ti99/cru.htm
******************************************************************************

* CRU R12 address and bits to select a keyboard column.
cru_write_keyboard_column equ >0024

cru_keyboard_column0 equ >0000 ; =     space enter        fctn shift ctrl
cru_keyboard_column1 equ >0100 ; .     L     O      9     2    W     S    X
cru_keyboard_column2 equ >0200 ; ,     K     I      8     3    D     E    C
cru_keyboard_column3 equ >0300 ; M     J     U      7     4    F     R    V
cru_keyboard_column4 equ >0400 ; N     H     Y      6     5    G     T    B
cru_keyboard_column5 equ >0500 ; /     ;     P      0     1    A     Q    Z
cru_keyboard_column6 equ >0600 ; fire1 left1 right1 down1 up1
cru_keyboard_column7 equ >0700 ; fire2 left2 right2 down2 up2

cru_keyboard_column_bit_count equ 3

* CRU R12 address and bits to read all or some of the selected keyboard
* column.
cru_read_keyboard_rows equ >0006

cru_read_keyboard_row0 equ >0006 ; =     .   ,   M   N   /  fire1  fire2
cru_read_keyboard_row1 equ >0008 ; space L   K   J   H   ;  left1  left2
cru_read_keyboard_row2 equ >000a ; enter O   I   U   Y   P  right1 right2
cru_read_keyboard_row3 equ >000c ;       9   8   7   6   0  down1  down2
cru_read_keyboard_row4 equ >000e ; fctn  2   3   4   5   1  up1    up2
cru_read_keyboard_row5 equ >0010 ; shift S   D   F   G   A
cru_read_keyboard_row6 equ >0012 ; ctrl  W   E   R   T   Q
cru_read_keyboard_row7 equ >0014 ;       X   C   V   B   Z

cru_test_keyboard_row0 equ 0 ; =     .   ,   M   N   /  fire1  fire2
cru_test_keyboard_row1 equ 1 ; space L   K   J   H   ;  left1  left2
cru_test_keyboard_row2 equ 2 ; enter O   I   U   Y   P  right1 right2
cru_test_keyboard_row3 equ 3 ;       9   8   7   6   0  down1  down2
cru_test_keyboard_row4 equ 4 ; fctn  2   3   4   5   1  up1    up2
cru_test_keyboard_row5 equ 5 ; shift S   D   F   G   A
cru_test_keyboard_row6 equ 6 ; ctrl  W   E   R   T   Q
cru_test_keyboard_row7 equ 7 ;       X   C   V   B   Z

cru_read_keyboard_row_bit_count equ 8

*****************************************************************************
* Macro: set the keyboard column.
* IN #1: the keyboard column number (0..7).
* LOCAL r0
* LOCAL r12

    .defm set_keyboard_column
    li   r12, cru_write_keyboard_column
    li   r0, #1 * 256
    ldcr r0, cru_keyboard_column_bit_count
    clr  r12
    .endm

*****************************************************************************
* Macro: test a single keyboard key in the current keyboard column.
* IN #1: the keyboard row number (0..7).
* OUT: equal status bit: 0 if pressed, 1 if not pressed.
* LOCAL r0
* LOCAL r12

    .defm test_keyboard_row
    tb   3 + #1
    .endm

*****************************************************************************
* Macro: test a single keyboard key.
* IN #1: the keyboard column number (0..7).
* IN #2: the keyboard row number (0..7).
* OUT: equal status bit: 0 if pressed, 1 if not pressed.
* LOCAL r0
* LOCAL r12

    .defm test_keyboard
    .set_keyboard_column #1
    .test_keyboard_row #2
    .endm
