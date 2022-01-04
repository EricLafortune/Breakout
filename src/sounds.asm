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
* Sound definitions.
******************************************************************************

* Each sound sequence is a 0-terminated sequence of sounds.
* A sound is a 0-terminated sequence of bytes for the sound processor.

* Macro: append the bytes of sound data for the chord.
    .defm chord_C
    .tone_frequency 0, note_C2
    .tone_frequency 1, note_E2
    .tone_frequency 2, note_G2
    .endm

* Macro: append the bytes of sound data for the chord.
    .defm chord_G
    .tone_frequency 2, note_G2
    .tone_frequency 0, note_B3
    .tone_frequency 1, note_D3
    .endm

* Macro: append the bytes of sound data for the chord.
    .defm chord_Am
    .tone_frequency 2, note_A3
    .tone_frequency 0, note_C3
    .tone_frequency 1, note_E3
    .endm

* Macro: append the bytes of sound data for the chord.
    .defm chord_F
    .tone_frequency 1, note_F2
    .tone_frequency 2, note_A3
    .tone_frequency 0, note_C3
    .endm

* Macro: append the bytes of sound data for the specified attenuation for all
*        tone generators (including a terminating 0).
* IN #1: the attenuation (0..14 for loud to quiet, 15 for off).
    .defm chord_attenuations
    .tone_attenuation 0, #1
    .tone_attenuation 1, #1
    .tone_attenuation 2, #1
    byte 0
    .endm

* Macro: append the bytes of sound data for a hard chord with increasing
*        attenuation (release).
    .defm chord_hard_release
    .chord_attenuations 0
    .chord_attenuations 1
    .chord_attenuations 2
    .chord_attenuations 3
    .chord_attenuations 4
    .chord_attenuations 5
    .chord_attenuations 6
    .chord_attenuations 7
    .chord_attenuations 8
    .chord_attenuations 9
    .chord_attenuations 10
    .chord_attenuations 11
    .chord_attenuations 12
    .chord_attenuations 13
    .chord_attenuations 14
    .chord_attenuations 15
    .endm

* Macro: append the bytes of sound data for a medium chord with increasing
*        attenuation (release).
    .defm chord_medium_release
    .chord_attenuations 2
    .chord_attenuations 3
    .chord_attenuations 4
    .chord_attenuations 5
    .chord_attenuations 6
    .chord_attenuations 7
    .chord_attenuations 8
    .chord_attenuations 9
    .chord_attenuations 10
    .chord_attenuations 11
    .chord_attenuations 12
    .chord_attenuations 13
    .chord_attenuations 13
    .chord_attenuations 14
    .chord_attenuations 14
    .chord_attenuations 15
    .endm

* Macro: append the bytes of sound data for a soft chord with increasing
*        attenuation (release).
    .defm chord_soft_release
    .chord_attenuations 4
    .chord_attenuations 5
    .chord_attenuations 6
    .chord_attenuations 7
    .chord_attenuations 8
    .chord_attenuations 9
    .chord_attenuations 10
    .chord_attenuations 11
    .chord_attenuations 11
    .chord_attenuations 12
    .chord_attenuations 12
    .chord_attenuations 13
    .chord_attenuations 13
    .chord_attenuations 14
    .chord_attenuations 14
    .chord_attenuations 15
    .endm

paddle_sound
    .noise_off
    .tone_frequency 0, note_A2
    .tone_attenuation 0, 0
    byte 0

    .tone_attenuation 0, 4
    byte 0

    .tone_attenuation 0, 8
    byte 0

    .tone_attenuation 0, 12
    byte 0

    .tone_off 0
    byte 0
    byte 0

edge_sound
    .noise_off
    .tone_frequency 0, note_C1
    .tone_attenuation 0, 0
    byte 0

    .tone_attenuation 0, 4
    byte 0

    .tone_attenuation 0, 8
    byte 0

    .tone_attenuation 0, 12
    byte 0

    .tone_off 0
    byte 0
    byte 0

brick_sound
    .tone_off 0
    .noise_frequency white_noise, 1
    .noise_attenuation 0
    byte 0

    .noise_attenuation 2
    byte 0

    .noise_frequency white_noise, 2
    .noise_attenuation 4
    byte 0

    .noise_attenuation 8
    byte 0

    .noise_attenuation 12
    byte 0

    .noise_attenuation 14
    byte 0

    .noise_off
    byte 0
    byte 0

ball_lost_sound
    .tone_off 0
    .noise_frequency white_noise, 0
    .noise_attenuation 4
    byte 0

    .noise_attenuation 3
    byte 0

    .noise_attenuation 2
    byte 0

    .noise_frequency white_noise, 1
    .noise_attenuation 3
    byte 0

    .noise_attenuation 4
    byte 0

    .noise_attenuation 5
    byte 0

    .noise_frequency white_noise, 2
    .noise_attenuation 6
    byte 0

    .noise_attenuation 8
    byte 0

    .noise_attenuation 10
    byte 0

    .noise_attenuation 12
    byte 0

    .noise_attenuation 14
    byte 0

    .noise_off
    byte 0
    byte 0

bonus_sound
    .noise_off
    .chord_C
    .chord_hard_release

    .chord_G
    .chord_soft_release

    .chord_Am
    .chord_medium_release

    .chord_F
    .chord_soft_release
    byte 0

game_lost_sound
    .noise_off
    .chord_Am
    .chord_hard_release

    .chord_F
    .chord_soft_release

    .chord_C
    .chord_medium_release

    .chord_G
    .chord_soft_release
    byte 0

high_score_sound
    .noise_off
    .chord_C
    .chord_hard_release

    .chord_G
    .chord_soft_release

    .chord_Am
    .chord_medium_release

    .chord_F
    .chord_soft_release

    .chord_C
    .chord_hard_release

    .chord_G
    .chord_soft_release

    .chord_Am
    .chord_medium_release

    .chord_F
    .chord_soft_release
    byte 0

silence
    .tone_off 0
    .noise_off
    byte 0
    byte 0
