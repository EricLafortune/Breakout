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
* Colors, sprites, and pattern definitions.
******************************************************************************

ball_chars         equ >00
paddle_chars       equ >04
digit_chars        equ >10     ; Digits in edge.
title_button_chars equ >1a
edge_char          equ >1d
copyright_char     equ '@'
arrow_chars        equ >80
button_chars       equ >88
bar_chars          equ >90
brick_char         equ >98
empty_char         equ >99

paddle_char1 equ paddle_chars + 0
paddle_char2 equ paddle_chars + 2

space_button_char1 equ title_button_chars + 0
space_button_char2 equ title_button_chars + 1
space_button_char3 equ title_button_chars + 2

redo_button_char1 equ button_chars + 0
redo_button_char2 equ button_chars + 1
back_button_char1 equ button_chars + 2
back_button_char2 equ button_chars + 3
quit_button_char1 equ button_chars + 4
quit_button_char2 equ button_chars + 5
button_edge_char  equ button_chars + 6

z_arrow_char1     equ arrow_chars + 0
z_arrow_char2     equ arrow_chars + 1
x_arrow_char1     equ arrow_chars + 2
x_arrow_char2     equ arrow_chars + 3
dot_arrow_char1   equ arrow_chars + 4
dot_arrow_char2   equ arrow_chars + 5
slash_arrow_char1 equ arrow_chars + 6
slash_arrow_char2 equ arrow_chars + 7

colors
    .color cyan, black         ; Paddle, ball.
    .color cyan, black
    .color black, light_blue   ; Digits in edge.
    .color black, light_blue

    .color white, black        ; Space,...
    .color white, black
    .color white, black        ; Digits.
    .color white, black
    .color white, black        ; Uppercase chars.
    .color white, black
    .color white, black
    .color white, black
    .color white, black        ; Lowercase chars.
    .color white, black
    .color white, black
    .color white, black

    .color light_green, black  ; Arrows.
    .color light_green, black  ; Buttons.
    .color light_red, black    ; Bar.
    .color blue, black         ; Brick.

copyright_pattern
    byte :00111100
    byte :01000010
    byte :10011001
    byte :10100001
    byte :10100001
    byte :10011001
    byte :01000010
    byte :00111100

sprite_patterns
    byte :00000000             ; Ball top left.
    byte :00111100
    byte :01111110
    byte :01111110
    byte :01111110
    byte :01111110
    byte :00111100
    byte :00000000

    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000

    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000

    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000

    byte :01111111             ; Paddle top left.
    byte :11111111
    byte :11111111
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000

    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000

    byte :11111110             ; Paddle top right.
    byte :11111111
    byte :11111111
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000

    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000

title_button_patterns
    byte :00000000             ; Space button.
    byte :00110110
    byte :01000101
    byte :00100110
    byte :00010100
    byte :01100100
    byte :00000000
    byte :11111111

    byte :00000000
    byte :00100011
    byte :01010100
    byte :01110100
    byte :01010100
    byte :01010011
    byte :00000000
    byte :11111111

    byte :00000111
    byte :01110111
    byte :01000111
    byte :01100111
    byte :01000111
    byte :01110111
    byte :00000111
    byte :11111111

    byte :00000000             ; Solid edge.
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000

arrow_patterns
    byte :00000001
    byte :00000011
    byte :00000111
    byte :00001111
    byte :00011111
    byte :00111111
    byte :01100001
    byte :11111011

    byte :11110111
    byte :01100001
    byte :00111111
    byte :00011111
    byte :00001111
    byte :00000111
    byte :00000011
    byte :00000001

    byte :00000000
    byte :00000000
    byte :00000011
    byte :00000111
    byte :00001111
    byte :00011111
    byte :00101101
    byte :01110011

    byte :01110011
    byte :00101101
    byte :00011111
    byte :00001111
    byte :00000111
    byte :00000011
    byte :00000000
    byte :00000000

    byte :00000000
    byte :00000000
    byte :11000000
    byte :11100000
    byte :11110000
    byte :11111000
    byte :11111100
    byte :11111110

    byte :11111110
    byte :11011100
    byte :11011000
    byte :11110000
    byte :11100000
    byte :11000000
    byte :00000000
    byte :00000000

    byte :10000000
    byte :11000000
    byte :11100000
    byte :11110000
    byte :11111000
    byte :11111100
    byte :11111110
    byte :11111111

    byte :11111111
    byte :11011110
    byte :11111100
    byte :11111000
    byte :11110000
    byte :11100000
    byte :11000000
    byte :10000000

button_patterns
    byte :11111111             ; Redo button.
    byte :10011000
    byte :10101011
    byte :10011001
    byte :10101011
    byte :10101000
    byte :11111111
    byte :00000000

    byte :11111111
    byte :10011101
    byte :10101010
    byte :10101010
    byte :10101010
    byte :10011101
    byte :11111111
    byte :00000000

    byte :11111111             ; Back button.
    byte :10011101
    byte :10101010
    byte :10001000
    byte :10101010
    byte :10011010
    byte :11111111
    byte :00000000

    byte :11111111
    byte :11001010
    byte :10111001
    byte :10111011
    byte :10111001
    byte :11001010
    byte :11111111
    byte :00000000

    byte :11111111             ; Quit button.
    byte :11011010
    byte :10101010
    byte :10101010
    byte :10101010
    byte :11001101
    byte :11111111
    byte :00000000

    byte :11111111
    byte :10100011
    byte :10110111
    byte :10110111
    byte :10110111
    byte :10110111
    byte :11111111
    byte :00000000

    byte :10000000             ; Button edge.
    byte :10000000
    byte :10000000
    byte :10000000
    byte :10000000
    byte :10000000
    byte :10000000
    byte :00000000

empty_patterns
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000

bar_patterns
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :11110000

    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :11110000
    byte :11110000

    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :11110000
    byte :11110000
    byte :11110000

    byte :00000000
    byte :00000000
    byte :00000000
    byte :00000000
    byte :11110000
    byte :11110000
    byte :11110000
    byte :11110000

    byte :00000000
    byte :00000000
    byte :00000000
    byte :11110000
    byte :11110000
    byte :11110000
    byte :11110000
    byte :11110000

    byte :00000000
    byte :00000000
    byte :11110000
    byte :11110000
    byte :11110000
    byte :11110000
    byte :11110000
    byte :11110000

    byte :00000000
    byte :11110000
    byte :11110000
    byte :11110000
    byte :11110000
    byte :11110000
    byte :11110000
    byte :11110000

    byte :11110000
    byte :11110000
    byte :11110000
    byte :11110000
    byte :11110000
    byte :11110000
    byte :11110000
    byte :11110000

edge_patterns
    byte :11111111             ; Edge.
    byte :11111111
    byte :11111111
    byte :11111111
    byte :11111111
    byte :11111111
    byte :11111111
    byte :11111111

brick_patterns
    byte :00000000             ; Brick.
    byte :01111110
    byte :01000010
    byte :01000010
    byte :01000010
    byte :01000010
    byte :01111110
    byte :00000000


sprite_attributes
                               ; Balls.
    byte >d0                   ; Vertical position.
    byte >00                   ; Horizontal position.
    byte ball_chars
    byte white

    byte >d0                   ; Vertical position.
    byte >00                   ; Horizontal position.
    byte ball_chars
    byte white

    byte >d0                   ; Vertical position.
    byte >00                   ; Horizontal position.
    byte ball_chars
    byte white

    byte >d0                   ; Vertical position.
    byte >00                   ; Horizontal position.
    byte ball_chars
    byte white
                               ; Paddle.
    byte >d0                   ; Vertical position.
    byte >00                   ; Horizontal position.
    byte paddle_chars
    byte cyan

    byte >d0                   ; Terminating sprite.
    byte >00
