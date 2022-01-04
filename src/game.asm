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

*****************************************************************************
* Game code. We have partitioned the code in blocks that the main engine can
* load from VDP memory into scratchpad RAM and execute there.
*****************************************************************************

* Define some useful constants and macros.

r_sound_pointer equ r14

    copy "include/colors.asm"
    copy "include/grom.asm"
    copy "include/cru.asm"
    copy "sound_queue.asm"

* Global registers:
*   r6:  Paddle position.
*   r7:  Number of bricks remaining.
*   r8:  Time remaining.
*   r9:  Half-width of the game screen (in characters).
*   r10: Score (doubled, with redraw bit).
*   r11: Subroutine return address.
*   r12: CRU offset.
*   r13: High score.
*   r14: Sound pointer.
*   r15: The constant vdpwa, for more compact code.

*****************************************************************************
* Code block: initialize the graphics registers.

    aorg
    even
initialize_graphics_registers_vdp_start
    data initialize_graphics_registers_vdp_length
    xorg >8300

initialize_graphics_registers
    clr  r13                   ; Clear the high score.

    .queue_sound high_score_sound

    .vdpwa_in_register r15     ; Cache the vdpwa in r15.

    .vdpwr 1, >c2              ; Set double-sized sprites.
    .vdpwr 2, >02              ; Set the screen image table        at >0800.
    .vdpwr 3, >2d              ; Set the color table               at >0b40.
;   .vdpwr 4, >00              ; Keep the pattern descriptor table at >0000.
    .vdpwr 5, >17              ; Set the sprite attribute list     at >0b80.
;   .vdpwr 6, >00              ; Keep the sprite descriptor table  at >0000.
    .vdpwr 7, black            ; Set the background color.

    .load_and_branch initialize_font_definitions

    .check_size

    aorg
initialize_graphics_registers_vdp_start_swap equ ((initialize_graphics_registers_vdp_start+1)/256) | ((initialize_graphics_registers_vdp_start+1)*256)
initialize_graphics_registers_vdp_length     equ $ - initialize_graphics_registers_vdp_start - 2

*****************************************************************************
* Code block: initialize the font definitions.

    aorg
    even
initialize_font_definitions_vdp_start
    data initialize_font_definitions_vdp_length
    xorg >8300

initialize_font_definitions
    li   r0, >0015             ; Get an offset in the GROM.
    .grmwa r0                  ; (>00a5 or >00a9).
    movb @grmrd, r0
    srl  r0, 8
    ai   r0, >04b0 - >00a5     ; Derive the offset of the big font
                               ; (>04b0 or >04b4).

    li   r1, >4100             ; Set up the big font.
    li   r2, >0200
    bl   @copy_grom_to_vdp

    ai   r0, >0080             ; Set up the big font digits for the score.
    li   r1, >4080
    li   r2, 10 * 8
    bl   @copy_grom_to_vdp

    ai   r0, >0260             ; Set up the medium characters as lowercase.
    li   r1, >4300
    li   r2, 32
    bl   @copy_grom_font_to_vdp

    .load_and_branch initialize_graphics_definitions

*****************************************************************************
* Subroutine: copy the specified bytes from GROM to VDP RAM.
* IN r0: the GROM source address.
* IN r1: the VDP RAM destination address.
* IN r2: the number of bytes.
copy_grom_to_vdp
    .grmwa r0
    .vdpwa r1
    nop

copy_loop
    movb @grmrd, @vdpwd        ; Copy over a byte.
    dec  r2
    jne  copy_loop
    rt

*****************************************************************************
* Subroutine: copy the specified bytes of a 7-byte font from GROM to VDP RAM.
* IN r0: the GROM source address.
* IN r1: the VDP RAM destination address.
* IN r2: the number of characters.
* LOCAL r3
copy_grom_font_to_vdp
    .grmwa r0
    .vdpwa r1
    nop

character_copy_loop
    movb r2, @vdpwd            ; Write a 0-byte.
    li   r3, 7

character_byte_copy_loop
    movb @grmrd, @vdpwd        ; Copy over a byte.
    dec  r3
    jne  character_byte_copy_loop

    dec  r2
    jne  character_copy_loop
    rt

    .check_size

    aorg
initialize_font_definitions_vdp_start_swap equ ((initialize_font_definitions_vdp_start+1)/256) | ((initialize_font_definitions_vdp_start+1)*256)
initialize_font_definitions_vdp_length     equ $ - initialize_font_definitions_vdp_start - 2

*****************************************************************************
* Code block: initialize the graphics definitions.

    aorg
    even
initialize_graphics_definitions_vdp_start
    data initialize_graphics_definitions_vdp_length
    xorg >8300

initialize_graphics_definitions
    li   r0, graphics_definitions
graphics_definitions_loop
    mov  *r0+, r1              ; VDP RAM source address.
    jeq  graphics_definitions_end
    mov  *r0+, r2              ; VDP RAM destination address.
    mov  *r0+, r3              ; Size.

    .vdpwa r1
    li   r1, graphics_definitions_scratchpad
    mov  r3, r4
read_graphics_definitions_loop
    .vdprd *r1+
    dec  r4
    jne  read_graphics_definitions_loop

    .vdpwa r2
    li   r1, graphics_definitions_scratchpad
write_graphics_definitions_loop
    .vdpwd *r1+
    dec  r3
    jne  write_graphics_definitions_loop

    jmp  graphics_definitions_loop

graphics_definitions_end

    .load_and_branch draw_title_screen

graphics_definitions
    data sprite_patterns
    data >4000                 ; Sprite patterns at >0000 (char >00,...)
    data 64

    data title_button_patterns
    data >40d0
    data 32

    data copyright_pattern     ; Character pattern at >0200 (char '@').
    data >4200
    data 8

    data arrow_patterns        ; Character patterns at >0400 (char >80,...)
    data >4400
    data 64

    data button_patterns
    data >4440
    data 64

    data bar_patterns
    data >4480
    data 64

    data brick_patterns
    data >44c0
    data 8

    data empty_patterns
    data >44c8
    data 8

    data colors
    data >4b40                 ; Colors at >0b40.
    data 20

    data sprite_attributes
    data >4b80                 ; Sprite attributes at >0b80.
    data 5 * 4 + 2             ; Length.

    data 0

graphics_definitions_scratchpad
    bss 64

    .check_size

    aorg
initialize_graphics_definitions_vdp_start_swap equ ((initialize_graphics_definitions_vdp_start+1)/256) | ((initialize_graphics_definitions_vdp_start+1)*256)
initialize_graphics_definitions_vdp_length     equ $ - initialize_graphics_definitions_vdp_start - 2

*****************************************************************************
* Code block: title screen - draw the graphics.

    aorg
    even
draw_title_screen_vdp_start
    data draw_title_screen_vdp_length
    xorg >8300

draw_title_screen
    .vdpwr 7, blue             ; Set the background color.

    li   r0, >0015             ; Get an offset in the GROM.
    .grmwa r0                  ; (>00a5 or >00a9).
    movb @grmrd, r4
    srl  r4, 8
    ai   r4, >094c - >00a5     ; Derive the offset of the TI logo
                               ; (>094c or >0950).

    li   r0, >0048             ; Draw the screen at >0800.
    .vdpwa_s r0

    clr  r0                    ; Start counting the characters.
game_screen_loop0
    li   r1, empty_char * 256  ; Set the clear character as default.

    ci   r0, >0020             ; Top border?
    jl   write_edge_character0
    ci   r0, >0300             ; Bottom border?
    jhe  write_edge_character0

    mov  r0, r2                ; Left border?
    andi r2, >001f
    jeq  write_edge_character0
    ci   r2, 7                 ; Left space?
    jl   write_character0
    ci   r2, 31                ; Right border?
    jl   write_rom_characters

write_edge_character0
    li   r1, edge_char * 256   ; Use the edge character.
    jmp  write_character0

write_rom_characters
    mov  r4, r1                ; Compute the right byte of the TI logo.

    mov  r0, r2
    ai   r2, -39

    mov  r2, r3                ; Column number / 8 (bits) * 8 (patterns bytes).
    andi r3, >0018
    a    r3, r1

    mov  r2, r3                ; Row number & ~7 (pattern bytes) * 3 (chars).
    srl  r3, 8
    sla  r3, 3
    a    r3, r1
    sla  r3, 1
    a    r3, r1

    mov  r2, r3                ; Row number % 8 (pattern bytes).
    srl  r3, 5
    andi r3, >0007
    a    r3, r1

    .grmwa r1
    movb @grmrd, r1

    li   r2, 8
character_row_loop0
    li   r3, empty_char * 256
    sla  r1, 1
    jnc  !
    li   r3, brick_char * 256  ; Use the brick character.
!
    .vdpwd r3                  ; Write the character.

    inc  r0
    dec  r2
    jne  character_row_loop0
    jmp  game_screen_loop0

write_character0
    .vdpwd r1                  ; Write the character.
    inc  r0
    ci   r0, >0320             ; With an extra line off-screen.
    jl   game_screen_loop0

    .load_and_branch draw_title_screen2

    .check_size

    aorg
draw_title_screen_vdp_start_swap equ ((draw_title_screen_vdp_start+1)/256) | ((draw_title_screen_vdp_start+1)*256)
draw_title_screen_vdp_length     equ $ - draw_title_screen_vdp_start - 2

*****************************************************************************
* Code block: title screen - draw the texts.

    aorg
    even
draw_title_screen2_vdp_start
    data draw_title_screen2_vdp_length
    xorg >8300

draw_title_screen2
    li   r0, title_definitions
title_definitions_loop
    inc  r0                    ; Make sure we have an even address.
    andi r0, >fffe
    mov  *r0+, r1              ; Get the VDP RAM destination address.
    jeq  title_definitions_end
    .vdpwa r1

    clr  r1
write_title_loop
    movb *r0+, r1              ; Get the text byte.
    jeq  title_definitions_loop
    .vdpwd r1                  ; Write the text byte.
    jmp  write_title_loop

title_definitions_end
    .load_and_branch draw_title_screen3

title_definitions
    data >4882
    text 'Breakout!'
    byte 0
    even

    data >4a02
    byte redo_button_char1
    byte redo_button_char2
    byte button_edge_char
    byte back_button_char1
    byte back_button_char2
    byte button_edge_char
    byte quit_button_char1
    byte quit_button_char2
    byte button_edge_char
    byte 0
    even

    data >4a22
    byte z_arrow_char1
    byte x_arrow_char1
    text '    '
    byte dot_arrow_char1
    byte slash_arrow_char1
    byte 0
    even

    data >4a42
    byte z_arrow_char2
    byte x_arrow_char2
    byte ' '
    byte paddle_char1
    byte paddle_char2
    byte ' '
    byte dot_arrow_char2
    byte slash_arrow_char2
    byte 0
    even

    data >4a82
    text '@ 2021-2022'
    byte 0
    even

    data >4ac2
    text 'Eric Lafortune'
    byte 0
    even

    data >4afc
    byte space_button_char1
    byte space_button_char2
    byte space_button_char3
    data 0
    even

    data 0

    .check_size

    aorg
draw_title_screen2_vdp_start_swap equ ((draw_title_screen2_vdp_start+1)/256) | ((draw_title_screen2_vdp_start+1)*256)
draw_title_screen2_vdp_length     equ $ - draw_title_screen2_vdp_start - 2

*****************************************************************************
* Code block: title screen - draw the high score.

    aorg
    even
draw_title_screen3_vdp_start
    data draw_title_screen3_vdp_length
    xorg >8300

draw_title_screen3
                               ; Display the high score in the top right corner.
    .write_decimal r13, >089d, '0'

    li   r0, >904b             ; Make the paddle sprite invisible at >0b90.
    .vdpwa_s r0
    li   r0, >d000
    .vdpwd r0

    .load_and_branch initialize_title_data

    .check_size

    aorg
draw_title_screen3_vdp_start_swap equ ((draw_title_screen3_vdp_start+1)/256) | ((draw_title_screen3_vdp_start+1)*256)
draw_title_screen3_vdp_length     equ $ - draw_title_screen3_vdp_start - 2

*****************************************************************************
* Code block: title screen - initialize the ball positions and speeds.

    aorg
    even
initialize_title_data_vdp_start
    data initialize_title_data_vdp_length
    xorg >8300

initialize_title_data
    li   r9, 6                 ; Half-width of the playing field.
    li   r7, -1                ; Number of bricks remaining.
    clr  r10                   ; Score.

    .load_and_branch wait_title_screen ; Continue with the title loop.

    .check_free 16

    bss load_code - $ - 16

* Ball positions and speeds in a shared memory area that persists during the
* game loop. The ball positions and speeds are encoded per two bytes:
* Position mask = >ffe0 (8.3 bits unsigned fixed point).
* Speed mask    = >001f (2.3 bits signed fixed point).
ball_positions
    data >0803                 ; Horizontal position and speed.
    data >0709                 ; Vertical position and speed.

    data >f005
    data >0707

    data >0807
    data >b705

    data >f809
    data >b703
ball_positions_end

    aorg
initialize_title_data_vdp_start_swap equ ((initialize_title_data_vdp_start+1)/256) | ((initialize_title_data_vdp_start+1)*256)
initialize_title_data_vdp_length     equ $ - initialize_title_data_vdp_start - 2

*****************************************************************************
* Code block: reset to the first game screen.

    aorg
    even
reset_game_screen_vdp_start
    data reset_game_screen_vdp_length
    xorg >8300

reset_game_screen
    li   r9, 6                 ; Half-width of the playing field.
    clr  r10                   ; Score.

    .load_and_branch draw_game_screen ; Continue with the game screen.

    .check_free 16

    aorg
reset_game_screen_vdp_start_swap equ ((reset_game_screen_vdp_start+1)/256) | ((reset_game_screen_vdp_start+1)*256)
reset_game_screen_vdp_length     equ $ - reset_game_screen_vdp_start - 2

*****************************************************************************
* Code block: draw the game screen.

    aorg
    even
draw_game_screen_vdp_start
    data draw_game_screen_vdp_length
    xorg >8300

draw_game_screen
    .vdpwr 7, black            ; Set the background color.

    clr  r7                    ; Start counting the number of bricks.

    li   r0, >0048             ; Draw the screen at >0800.
    .vdpwa_s r0

    clr  r0                    ; Start counting the characters.
game_screen_loop
    li   r1, empty_char * 256  ; Set the clear character as default.

    mov  r0, r2                ; Time bar?
    andi r2, >001f
    jne  !

    li   r1, (bar_chars + 7) * 256
    jmp  write_character
!
    ci   r0, >0020             ; Top border?
    jl   write_edge_character

    ai   r2, -16               ; Left or right border?
    a    r9, r2
    sra  r2, 1
    c    r2, r9
    jl   !

write_edge_character
    li   r1, edge_char * 256   ; Use the edge character.
    jmp  write_character
!
    ci   r0, >0100             ; Brick?
    jhe  write_character
    li   r1, brick_char * 256  ; Use the brick character.
    inc  r7

write_character
    .vdpwd r1                  ; Write the character.
    inc  r0
    ci   r0, >0320             ; With an extra line off-screen.
    jl   game_screen_loop

    .load_and_branch initialize_game_data

    .check_size

    aorg
draw_game_screen_vdp_start_swap equ ((draw_game_screen_vdp_start+1)/256) | ((draw_game_screen_vdp_start+1)*256)
draw_game_screen_vdp_length     equ $ - draw_game_screen_vdp_start - 2

*****************************************************************************
* Code block: initialize the game ball positions and speeds.

    aorg
    even
initialize_game_data_vdp_start
    data initialize_game_data_vdp_length
    xorg >8300

horizontal_ballspeed equ >0040
vertical_ballspeed   equ >0080

initialize_game_data
    li   r6, >7800             ; Paddle horizontal position.
    li   r8, >c000             ; Time remaining.

    li   r0, >904b             ; Make the paddle sprite visible at >0b90.
    .vdpwa_s r0
    li   r0, >bb00
    .vdpwd r0

    .load_and_branch paddle_movement ; Continue with the game loop.

    .check_free 16

    bss load_code - $ - 16

* Ball positions and speeds in a shared memory area that persists during the
* game loop. The ball positions and speeds are encoded per two bytes:
* Position mask = >ffe0 (8.3 bits unsigned fixed point).
* Speed mask    = >001f (2.3 bits signed fixed point).
;ball_positions
    data >8000                 ; Horizontal position and speed.
    data >6004                 ; Vertical position and speed.

    data >501f
    data >0702

    data >8000
    data >0702

    data >a801
    data >0702
;ball_positions_end

    aorg
initialize_game_data_vdp_start_swap equ ((initialize_game_data_vdp_start+1)/256) | ((initialize_game_data_vdp_start+1)*256)
initialize_game_data_vdp_length     equ $ - initialize_game_data_vdp_start - 2

*****************************************************************************
* Macro: update the given position with a single step at its speed (one
*        dimension).
* IN OUT #1: the register with the position/speed.
* LOCAL  r2: a temporary register.

    .defm update_position
    mov  #1, r2                 ; Speed in bits >001f.
    sla  r2, 11                 ; Speed in bits >f800.
    sra  r2, 6                  ; Speed in bits >ffe0.
    a    r2, #1                 ; Update the position.
    .endm

*****************************************************************************
* Macro: put the given speed in the given encoded position/speed.
* IN     #1: the register with the new speed.
* IN OUT #2: the register with the original position/speed.

    .defm replace_speed
    andi #1, >001f              ; Mask the new speed.
    andi #2, >ffe0              ; Mask out the old speed.
    soc  #1, #2                 ; Set the speed.
    .endm

*****************************************************************************
* Macro: negate the speed in the given encoded position/speed (one dimension).
* IN OUT #1: the register with the position/speed.
* LOCAL  r0: a temporary register.

    .defm negate_speed
    andi #1, >ffdf              ; Drop the least significant bit of the pos.
    li   r0, >001f              ; Negate the speed (invert, add 1).
    xor  r0, #1
    inc  #1
    .endm

*****************************************************************************
* Code block: title screen - wait for a key press.

    aorg
    even
wait_title_screen_vdp_start
    data wait_title_screen_vdp_length
    xorg >8300

wait_title_screen
    .test_keyboard 0, 0        ; Key '='?
    jeq  !
    clr  @>83c4                ; Clear the custom interrupt address.
    blwp @0                    ; Quit.
!
    .test_keyboard 0, 1        ; Key ' '?
    jeq  continue_title_screen

wait_release_loop
    .test_keyboard_row 1       ; Release key ' '?
    jne  wait_release_loop

    .load_and_branch reset_game_screen; Start the game.

continue_title_screen
    .load_and_branch ball_brick       ; Continue animating the title screen.

    .check_free 16

    aorg
wait_title_screen_vdp_start_swap equ ((wait_title_screen_vdp_start+1)/256) | ((wait_title_screen_vdp_start+1)*256)
wait_title_screen_vdp_length     equ $ - wait_title_screen_vdp_start - 2

*****************************************************************************
* Code block: pause.

    aorg
    even
pause_vdp_start
    data pause_vdp_length
    xorg >8300

pause
    .test_keyboard_row 1       ; Release key ' '?
    jne  pause

unpause_loop
    .test_keyboard 0, 0        ; Key '='?
    jeq  !
    clr  @>83c4                ; Clear the custom interrupt address.
    blwp @0                    ; Quit.
!
   .test_keyboard 1, 3         ; Key '9'?
    jeq  !
    .load_and_branch reset_game_screen
!
    .test_keyboard 5, 3        ; Key '0'?
    jeq  !
    .load_and_branch end_game
!
    .test_keyboard 0, 1        ; Key ' '?
    jeq  unpause_loop

unpause_release_loop
    .test_keyboard_row 1       ; Release key ' '?
    jne  unpause_release_loop

    .load_and_branch paddle_movement

    .check_free 16

    aorg
pause_vdp_start_swap equ ((pause_vdp_start+1)/256) | ((pause_vdp_start+1)*256)
pause_vdp_length     equ $ - pause_vdp_start - 2

*****************************************************************************
* Code block: main game loop - paddle movement.

    aorg
    even
paddle_movement_vdp_start
    data paddle_movement_vdp_length
    xorg >8300

paddle_speed equ >0100

cru_read_keyboard_row_bit_count equ 8

paddle_movement
    .set_keyboard_column 0     ; Keys '=' ... 'ctrl'?

    .test_keyboard_row 0       ; Key '='?
    jeq  !
    clr  @>83c4                ; Clear the custom interrupt address.
    blwp @0                    ; Quit.
!
    .test_keyboard_row 1       ; Key ' '?
    jeq  !
    .load_and_branch pause
!
   .test_keyboard 1, 3         ; Key '9'?
    jeq  !
    .load_and_branch reset_game_screen
!
    .set_keyboard_column 5     ; Keys '/' ... 'Z'.
!
    .test_keyboard_row 3       ; Key '0'?
    jeq  !
    .load_and_branch end_game
!
    .test_keyboard_row 7       ; Key 'Z'?
    jeq  !
    ai   r6, -2*paddle_speed
!
    .test_keyboard_row 0       ; Key '/'?
    jeq  !
    ai   r6, 2*paddle_speed
!

    .set_keyboard_column 1     ; Keys '.' ... 'X'.

    .test_keyboard_row 7       ; Key 'X'?
    jeq  !
    ai   r6, -paddle_speed
!
    .test_keyboard_row 0       ; Key '.'?
    jeq  !
    ai   r6, paddle_speed
!
    mov  r9, r0                ; Check the left edge.
    sla  r0, 11
    neg  r0
    ai   r0, >8000
    c    r6, r0
    jhe  !
    mov  r0, r6
!
    mov  r9, r0                ; Check the right edge.
    sla  r0, 11
    ai   r0, >7000
    c    r6, r0
    jle  !
    mov  r0, r6
!
    li   r1, >914b             ; Write the horizontal paddle position at >0b91.
    .vdpwa_s r1
    nop
    .vdpwd r6

    .load_and_branch ball_paddle

    .check_free 16

    aorg
paddle_movement_vdp_start_swap equ ((paddle_movement_vdp_start+1)/256) | ((paddle_movement_vdp_start+1)*256)
paddle_movement_vdp_length     equ $ - paddle_movement_vdp_start - 2

*****************************************************************************
* Code block: main game loop - ball/paddle collision.

    aorg
    even
ball_paddle_vdp_start
    data ball_paddle_vdp_length
    xorg >8300

ball_paddle
    li   r3, ball_positions

ball_paddle_loop
    mov  *r3+, r4              ; Get the position and speed.
    mov  *r3+, r5
    jeq  no_ball_paddle_collision

    ci   r5, >b400             ; Is the ball hitting the paddle?
    jl   no_ball_paddle_collision
    li   r0, >fc00
    ab   r4, r0
    sb   r6, r0
    ci   r0, >f600
    jlt  no_ball_paddle_collision
    ci   r0, >0a00
    jgt  no_ball_paddle_collision

    sra  r0, 9                 ; Compute the horizontal speed (-5..5)

    mov  r0, r1                ; Compute the vertical speed as a parabolic
    mpy  r0, r1                ; function of the horizontal speed (always
    ai   r2, -128              ; negative).
    sra  r2, 4

    .replace_speed r0, r4      ; Update the speed.
    .replace_speed r2, r5

    mov  r4, @-4(r3)           ; Store the new position and speed.
    mov  r5, @-2(r3)

    .queue_sound paddle_sound

no_ball_paddle_collision
    ci   r3, ball_positions_end
    jl   ball_paddle_loop

    .load_and_branch ball_brick

    .check_free 16

    aorg
ball_paddle_vdp_start_swap equ ((ball_paddle_vdp_start+1)/256) | ((ball_paddle_vdp_start+1)*256)
ball_paddle_vdp_length     equ $ - ball_paddle_vdp_start - 2

*****************************************************************************
* Code block: main game loop - ball/brick collision.

    aorg
    even
ball_brick_vdp_start
    data ball_brick_vdp_length
    xorg >8300

ball_brick
    li   r3, ball_positions

ball_brick_loop
    mov  *r3+, r4               ; Is the ball hitting a brick horizontally?
    mov  *r3+, r5
    jeq  no_ball_brick_collision

    mov  r4, r0
    mov  r5, r1

    .update_position r0

    bl   @check_brick
bounce_begin1
    .negate_speed r4
    mov  r4, @-4(r3)
bounce_end1

    mov  r4, r0                 ; Is the ball hitting a brick vertically?
    mov  r5, r1

    .update_position r1

    bl   @check_brick
bounce_begin2
    .negate_speed r5
    mov  r5, @-2(r3)
bounce_end2

no_ball_brick_collision
    ci   r3, ball_positions_end
    jl   ball_brick_loop

    .load_and_branch ball_movement

* Subroutine: check the character at the specified position. Clear it if it's a
*             brick. Skip the bounce code of the caller if it's an empty space.
* IN r0: the horizontal position (in the MSB).
* IN r1: the vertical position (in the MSB).
check_brick
    ai   r0, >0400             ; Compute the character position.
    srl  r0, 11
    ai   r1, >0500
    srl  r1, 11
    sla  r1, 5
    a    r1, r0
    ai   r0, >0800             ; The screen image table at >0800.
    .vdpwa r0

    clr  r1                    ; Get the character.
    .vdprd r1
    ci   r1, brick_char * 256  ; Is it an edge/brick/empty?
    jeq  clear_brick
    jl   bounce_edge

no_brick                       ; Empty.
    ai   r11, bounce_end1 - bounce_begin1
    rt                         ; Return without bouncing.

clear_brick                    ; Brick.
    ori  r0, >4000             ; Clear the brick.
    .vdpwa r0
    li   r1, empty_char * 256
    .vdpwd r1

    dec  r7                    ; Decrement the remaining brick count.

    inct r10                   ; Increase the score.
    ori  r10, 1

    .queue_sound_if_quiet brick_sound
    rt                         ; Return and bounce.

bounce_edge                    ; Edge.
    .queue_sound_if_quiet edge_sound
    rt                         ; Return and bounce.

    .check_free 16

    aorg
ball_brick_vdp_start_swap equ ((ball_brick_vdp_start+1)/256) | ((ball_brick_vdp_start+1)*256)
ball_brick_vdp_length     equ $ - ball_brick_vdp_start - 2

*****************************************************************************
* Code block: main game loop - ball movement.

    aorg
    even
ball_movement_vdp_start
    data ball_movement_vdp_length
    xorg >8300

update_ball_positions          ; Update and write the ball position.
    li   r3, ball_positions
    li   r4, >4b80             ; Destination >0b84 in VDP memory.

    clr  r5                    ; Start counting the number of active balls.

update_ball_positions_loop
    mov  *r3+, r0              ; Get the position and speed.
    mov  *r3+, r1
    jeq  no_ball_update

    inc  r5

    .update_position r0        ; Compute the new position.
    .update_position r1

    .vdpwa r4
    nop
    .vdpwd r1                  ; Write the vertical position.
    nop
    .vdpwd r0                  ; Write the horizontal position.

    ci   r1, >bf00             ; Has the ball dropped below the playing field?
    jl   !
    clr  r0                    ; Clear its position and speed.
    clr  r1

    .queue_sound ball_lost_sound
!
    mov  r0, @-4(r3)           ; Store the new position and speed.
    mov  r1, @-2(r3)

no_ball_update
    ai   r4, 4
    ci   r3, ball_positions_end
    jl   update_ball_positions_loop

    mov  r5, r5                ; Are there any active balls left?
    jne  !
    li   r8, 4                 ; Clear the remaining time.
!
    .load_and_branch play_sound

    .check_free 16

    aorg
ball_movement_vdp_start_swap equ ((ball_movement_vdp_start+1)/256) | ((ball_movement_vdp_start+1)*256)
ball_movement_vdp_length     equ $ - ball_movement_vdp_start - 2

*****************************************************************************
* Code block: main game loop - play sound.

    aorg
    even
play_sound_vdp_start
    data play_sound_vdp_length
    xorg >8300

play_sound
    .play_sound_queue

    mov  r7, r7                ; Are we on the title screen?
    jlt  !
    .load_and_branch update_score      ; Continue in the game loop.
!
    .load_and_branch wait_title_screen ; Continue with the title screen loop.

    .check_free 16

    aorg
play_sound_vdp_start_swap equ ((play_sound_vdp_start+1)/256) | ((play_sound_vdp_start+1)*256)
play_sound_vdp_length     equ $ - play_sound_vdp_start - 2

*****************************************************************************
* Code block: main game loop - update the score and the remaining time.

    aorg
    even
update_score_vdp_start
    data update_score_vdp_length
    xorg >8300

update_score

* Add a time bonus if all bricks have been cleared.
    mov  r7, r7                ; Are all bricks cleared?
    jne  not_adding_bonus
    inct r10                   ; Add the time bonus to the score.
    ori  r10, 1
    andi r8, >ff00             ; Decrease the remaining bonus time.
    ai   r8, >ff04

    .queue_sound_if_quiet bonus_sound

not_adding_bonus
    ai   r8, -4                ; Update the time.

    .load_and_branch display_score

    .check_free 16

    aorg
update_score_vdp_start_swap equ ((update_score_vdp_start+1)/256) | ((update_score_vdp_start+1)*256)
update_score_vdp_length     equ $ - update_score_vdp_start - 2

*****************************************************************************
* Code block: main game loop - display the score and the remaining time.

    aorg
    even
display_score_vdp_start
    data display_score_vdp_length
    xorg >8300

display_score

* Display the score.
    srl  r10, 1                ; Only display the score if it has changed (odd).
    jnc  dont_write_score
                               ; Display the score in the top right corner.
    .write_decimal r10, >083f, digit_chars

dont_write_score
    sla  r10, 1

* Display the remaining time.
    mov  r8, r0                ; Update the time bar.
    srl  r0, 11
    sla  r0, 5
    neg  r0
    ai   r0, >4ae0
    .vdpwa r0

    mov  r8, r0
    andi r0, >0700
    ai   r0, (bar_chars - 1) * 256
    .vdpwd r0

    mov  r8, r8                ; Are we out of time?
    jne  !
    .load_and_branch end_screen        ; End the screen.
!
    mov  r7, r7                ; Are all bricks cleared?
    jne  !
    .load_and_branch play_sound        ; Continue adding the time bonus.
!
    .load_and_branch paddle_movement   ; Continue with the game loop.

    .check_free 16

    aorg
display_score_vdp_start_swap equ ((display_score_vdp_start+1)/256) | ((display_score_vdp_start+1)*256)
display_score_vdp_length     equ $ - display_score_vdp_start - 2

*****************************************************************************
* Code block: end the current screen.

    aorg
    even
end_screen_vdp_start
    data end_screen_vdp_length
    xorg >8300

end_screen
    mov  r7, r7                ; Are there any bricks left?
    jeq  !
    .load_and_branch end_game          ; End the game.
!
    ci   r9, 12                ; Increment the playing field half-width,
    jhe  !                     ; if possible.
    inc  r9
!
    .load_and_branch draw_game_screen  ; Continue with the next screen.

    .check_size

    aorg
end_screen_vdp_start_swap equ ((end_screen_vdp_start+1)/256) | ((end_screen_vdp_start+1)*256)
end_screen_vdp_length     equ $ - end_screen_vdp_start - 2

*****************************************************************************
* Code block: end the current game. Update the high score.

    aorg
    even
end_game_vdp_start
    data end_game_vdp_length
    xorg >8300

end_game
    .queue_sound game_lost_sound

    srl  r10, 1                ; Did we beat the high score?
    c    r10, r13
    jl   !
    mov  r10, r13              ; Update it.

    .queue_sound high_score_sound
!
    .load_and_branch draw_title_screen ; Continue with the title screen.

    .check_size

    aorg
end_game_vdp_start_swap equ ((end_game_vdp_start+1)/256) | ((end_game_vdp_start+1)*256)
end_game_vdp_length     equ $ - end_game_vdp_start - 2

*****************************************************************************
* Graphics definitions that are copied from VDP RAM to VDP RAM.

    aorg
    even

    copy "graphics.asm"

* Sound definitions that are copied from VDP RAM to the sound chip.

    aorg
    even

    copy "sounds.asm"
