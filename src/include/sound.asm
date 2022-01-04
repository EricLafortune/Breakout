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
* Definitions and macros for accessing sound and speech.
*
* Programming them is documented in
*     http://www.unige.ch/medecine/nouspikel/ti99/tms9919.htm
*     http://www.unige.ch/medecine/nouspikel/ti99/speech.htm
******************************************************************************

* Frequency dividers for a well-tempered keyboard.
note_A0  equ >03f9
note_AS0 equ >03c0
note_B0  equ >038a

note_C1  equ >0357
note_CS1 equ >0327
note_D1  equ >02fa
note_DS1 equ >02cf
note_E1  equ >02a7
note_F1  equ >0281
note_FS1 equ >025d
note_G1  equ >023b
note_GS1 equ >021b
note_A1  equ >01fc
note_AS1 equ >01e0
note_B1  equ >01c5

note_C2  equ >01ac
note_CS2 equ >0194
note_D2  equ >017d
note_DS2 equ >0168
note_E2  equ >0153
note_F2  equ >0140
note_FS2 equ >012e
note_G2  equ >011d
note_GS2 equ >010d
note_A2  equ >00fe
note_AS2 equ >00f0
note_B2  equ >00e2

note_C3  equ >00d6
note_CS3 equ >00ca
note_D3  equ >00be
note_DS3 equ >00b4
note_E3  equ >00aa
note_F3  equ >00a0
note_FS3 equ >0097
note_G3  equ >008f
note_GS3 equ >0087
note_A3  equ >007f
note_AS3 equ >0078
note_B3  equ >0071

note_C4  equ >006b
note_CS4 equ >0065
note_D4  equ >005f
note_DS4 equ >005a
note_E4  equ >0055
note_F4  equ >0050
note_FS4 equ >004c
note_G4  equ >0047
note_GS4 equ >0043
note_A4  equ >0040
note_AS4 equ >003c
note_B4  equ >0039

note_C5  equ >0035
note_CS5 equ >0032
note_D5  equ >0030
note_DS5 equ >002d
note_E5  equ >002a
note_F5  equ >0028
note_FS5 equ >0026
note_G5  equ >0024
note_GS5 equ >0022
note_A5  equ >0020
note_AS5 equ >001e
note_B5  equ >001c

note_C6  equ >001b
note_CS6 equ >0019
note_D6  equ >0018
note_DS6 equ >0016
note_E6  equ >0015
note_F6  equ >0014

periodic_noise equ 0
white_noise    equ 1

* Sound address.
sound  equ  >8400

* Speech addresses.
spchrd equ  >9000
spchwt equ  >9400

* Macro: append the bytes of sound data for the specified tone frequency.
* IN #1: the tone generator (0..2).
* IN #2: the frequency divider (1..1023 for high to low).
    .defm tone_frequency
    byte >80 | (#1 * 32) | (#2 & >000f)
    byte >00 | ((#2 & >03f0) / 16)
    .endm

* Macro: append the byte of sound data for the specified tone attenuation.
* IN #1: the tone generator (0..2).
* IN #2: the attenuation (0..14 for loud to quiet, 15 for off).
    .defm tone_attenuation
    byte >90 | (#1 * 32) | (#2 & >0f)
    .endm

* Macro: append the byte of sound data for switching the specified tone off.
* IN #1: the tone generator (0..2).
    .defm tone_off
    byte >9f | (#1 * 32)
    .endm

* Macro: append the byte of sound data for the specified noise frequency.
* IN #1: periodic_noise or white_noise.
* IN #2: the frequency divider (0..3, where 3 means use generator 3).
    .defm noise_frequency
    byte >e0 | (#1 * 4) | (#2 & >03)
    .endm

* Macro: append the byte of sound data for the specified noise attenuation.
* IN #1: the attenuation (0..14 for loud to quiet, 15 for off).
    .defm noise_attenuation
    byte >f0 | (#1 & >0f)
    .endm

* Macro: append the byte of sound data for switching noise off.
* IN #1: the tone generator (0..2).
    .defm noise_off
    byte >ff
    .endm


* Macro: write the given value to the sound generator.
* IN #1: the source.
    .defm sound
    movb #1, @sound
    .endm

* Macro: read a value from the speech synthesizer.
* OUT #1: the destination.
    .defm spchrd
    movb @spchrd, #1
    .endm

* Macro: write the given value to the speech synthesizer.
* IN #1: the source.
    .defm spchwt
    movb #1, @spchwt
    .endm
