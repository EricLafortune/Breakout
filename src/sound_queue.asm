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
* Macros for managing a sound queue.
*
* Each sound sequence is a 0-terminated sequence of sounds.
* A sound is a 0-terminated sequence of bytes for the sound processor.
******************************************************************************

* Define some useful constants and macros.
    copy "include/sound.asm"

* Macro: clear the sound queue.
    .defm clear_sound_queue
    clr  r_sound_pointer
    .endm

* Macro: queue a sound.
* IN #1: the address of the sound definitions in VDP RAM.
    .defm queue_sound
    li   r_sound_pointer, #1
    .endm

* Macro: queue a sound, if no other sound is playing.
* IN #1: the address of the sound definitions in VDP RAM.
    .defm queue_sound_if_quiet
                                ; Is the queue empty?
    mov  r_sound_pointer, r_sound_pointer
    jne  !
    .queue_sound #1
!
    .endm

* Macro: play the queued sequence of bytes.
    .defm play_sound_queue
                               ; Do we have any sounds in the queue?
    mov  r_sound_pointer, r_sound_pointer
    jeq  !!!

    .vdpwa r14                 ; Write the VDP source address.
    clr  r0
!                              ; Loop over the current sequence of bytes.
    inc  r14
    .vdprd r0                  ; Read the sound byte from VDP RAM.
    jeq  !
    .sound r0                  ; Write the sound byte to the sound processor.
    jmp  -!
!
    .vdprd r0                  ; Was this the last sequence of bytes?
    jne  !
    clr  r14
!
    .endm
