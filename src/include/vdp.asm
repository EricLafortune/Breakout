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
* Definitions and macros for accessing the Video Display Processor (VDP) and
* VDP RAM.
*
* The VDP is documented in
*     http://www.unige.ch/medecine/nouspikel/ti99/tms9918a.htm
******************************************************************************

* VDP register write addresses (including the register bit >8000).
vdp_r0 equ >8000
vdp_r1 equ >8100
vdp_r2 equ >8200
vdp_r3 equ >8300
vdp_r4 equ >8400
vdp_r5 equ >8500
vdp_r6 equ >8600
vdp_r7 equ >8700

* VDP addresses.
vdpwa  equ  >8c02
vdprd  equ  >8800
vdpwd  equ  >8c00
vdpsta equ  >8802

* Macro: cache the vdpwa constant in the given register, to automatically get
*        more compact vdpwa macro calls later on.
* IN #1:  the register number.
* OUT #1: the vdpwa constant.
    .defm vdpwa_in_register
r_vdpwa equ #1
    li   r_vdpwa, vdpwa
    .endm

* Macro: write the given VDP address.
* IN #1: the register containing the VDP address
*        (including the register bit >8000 or write bit >4000 if necessary).
    .defm vdpwa
    .ifdef r_vdpwa
    swpb #1
    movb #1, *r_vdpwa
    swpb #1
    movb #1, *r_vdpwa
    .else
    swpb #1
    movb #1, @vdpwa
    swpb #1
    movb #1, @vdpwa
    .endif
    .endm

* Macro: write the given VDP address.
* IN #1: the register containing the VDP address, pre-swapped
*        (including the register bit >8000 or write bit >4000 if necessary).
    .defm vdpwa_s
    .ifdef r_vdpwa
    movb #1, *r_vdpwa
    swpb #1
    movb #1, *r_vdpwa
    .else
    movb #1, @vdpwa
    swpb #1
    movb #1, @vdpwa
    .endif
    .endm

* Macro: read the value from VDP memory at the current VDP address.
* OUT #1: the destination.
    .defm vdprd
    movb @vdprd, #1
    .endm

* Macro: write the given value to VDP memory at the current VDP address.
* IN #1: the source.
    .defm vdpwd
    movb #1, @vdpwd
    .endm

* Macro: write the given value to the given VDP register.
* IN #1: the register number.
* IN #2: the register value.
* OUT r0: the VDP address.
*        (including the register bit >8000 or write bit >4000 if necessary).
    .defm vdpwr
    li   r0, #2 * 256 + >0080 + #1
    .vdpwa_s r0
    .endm

* Macro: write a decimal number at the given VDP address.
* IN #1: the register that contains the value.
* IN #2: the target location of the last digit.
* IN #3: the character number of digit '0', e.g. 48.
* LOCAL r0
* LOCAL r1
* LOCAL r2
* LOCAL r3
    .defm write_decimal
    mov  #1, r1
    li   r3, >4000 + #2
    li   r2, 10

!   clr  r0                    ; Compute the least significant digit.
    div  r2, r0

    sla  r1, 8
    ai   r1, (#3) * 256        ; Add the '0' char to the digit.

    .vdpwa r3                  ; Write the address of the digit.
    dec  r3

    .vdpwd r1                  ; Write the digit.

    mov  r0, r1                ; Loop until the value is 0.
    jne  -!
    .endm
