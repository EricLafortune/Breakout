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
* The entry point of the program. It compiles to a TI BASIC program file.
* The program escapes the TI BASIC sandbox and launches the assembly code of
* the actual game.
*
* The assembly code runs from the CPU scratchpad RAM: program blocks of up
* to 198 bytes, 26 bytes of shared memory swapping code, and 32 bytes of
* register workspace.
*****************************************************************************

* Define some useful constants and macros.

    copy "include/basic_tokens.asm"
    copy "include/vdp.asm"

*****************************************************************************
* Macro: load a block of code from VDP RAM and branch to it.
* IN #1: the address of the block in VDP RAM (a length byte followed by the
*        actual data), swapped (for efficiency when sending it to the VDP).

    .defm load_and_branch
    li   r0, #1_vdp_start_swap
    jmp  load_code
    .endm

*****************************************************************************
* We locate all data and code as they are present in VDP RAM.
* The aorg directives take care of any padding in the file.
* The xorg directives ensure correct label offsets in the code.

basic_program_length equ >10b0
basic_program_start  equ >37d8 - basic_program_length
basic_program_end    equ basic_program_start + basic_program_length

    aorg basic_program_start - 8

* The BASIC program file header (8 bytes, not part of program in VDP memory).
    data checksum
    data line_number_table_end
    data line_number_table_start
    data basic_program_end - 1

* The BASIC program.
line_number_table_start        ; Lines in reverse order.
    data 0
    data payload_tokens
line_number_table_end equ $ - 1

checksum equ line_number_table_end ^ line_number_table_start

token_table_start
    byte payload_tokens_length
payload_tokens                 ; BASIC line OPEN #1:"... <payload> ..."
    byte token_open
    byte token_hash
    byte token_unquoted_string
    byte >02
    text '01'                  ; Padded to get an even payload offset.
    byte token_colon
    byte token_quoted_string
    byte payload_string_length
payload_string_start

*****************************************************************************
* The string is the payload that the OPEN statement copies to the scratchpad
* RAM for us. Its length is larger than >7f, which defeats the length check of
* the OPEN implementation (signed byte check in GPL). We can thus overwrite
* all relevant contents (>b6 bytes at >834a .. >83ff).
* The payload must not contain a filename separator '.' (>2e), as OPEN would
* then truncate it.
* The contents of the standard scratchpad RAM are documented in
*     http://www.unige.ch/medecine/nouspikel/ti99/padram.htm

    xorg >834a

payload
    bss  >8364 - $             ; Padding to get to >8364, which is >0664 with
                               ; the first byte changed to >83; see the GPL
                               ; interpreter workspace below.

* Our executable payload code. When we end up here, we've escaped the
* sandbox.
payload_code
    .vdpwa_in_register r15     ; Put vdpwa in r15, for more compact code.

    .load_and_branch initialize_graphics_registers ; Continue with the game.

    bss  >83c6 - $             ; Padding to get to >83c6, which is >83e0
                               ; minus 26 bytes for the shared code snippet
                               ; below.

* Shared code snippet: copy a block of code from VDP RAM to CPU scratchpad RAM
*                      (starting at >8300) and branch to it.
* IN r0: the VDP source address.
* IN r1: the number of bytes.
load_code
    .vdpwa_s r0                ; Write the pre-swapped VDP source address.
    li   r0, >8300             ; Set the RAM destination.
    movb @vdprd, r1            ; Read the length.
    srl  r1, 8
load_code_loop                 ; Copy the bytes.
    movb @vdprd, *r0+
    dec  r1
    jne  load_code_loop
    jmp  >8300                 ; Branch to the code that we just copied.

* GPL interpreter workspace during the GPL MOVE instruction. The console ROM
* code branches to our payload code after it has copied our byte >83 to RAM
* address >83ec, which is the MSB of r6.
    data >0000 ; r0
    aorg
    data $ + 2 ; r1  VDP source address of the next byte (must be in the same
               ;     >0100 page as in the live string below the program).
               ;     The MOVE instruction then continues copying this original
               ;     of the live string.
    xorg >83e4
    data $ + 2 ; r2  RAM destination address of the next byte.
    data >8358 ; r3
    data >0090 ; r4
    data >011e ; r5
    data >8364 ; r6  Address of the code for GPL MOVE source VDP (was >0664).
    data >0682 ; r7  Address of the code for GPL MOVE destination RAM.
    data >00b6 ; r8  Remaining number of bytes to copy.
    data >0000 ; r9
    data >0560 ; r10
    data >0000 ; r11 Byte that is copied.
    data >0000 ; r12
    data >9800 ; r13
    data >0108 ; r14
    data >8c02 ; r15 VDP write address.

* End of the string that is copied to scratchpad RAM.
*****************************************************************************

    aorg
payload_string_length equ $ - payload_string_start
    byte token_line_terminator
payload_tokens_length equ $ - payload_tokens

*****************************************************************************
* Macro: check if the current code block still has bytes available.
* IN #1: the number of bytes reserved for data after the code block.

    .defm  check_free
    ; The print macro doesn't seem to accept the #1 macro argument.
    .print 'Code block:', load_code - $ - 16, 'bytes free (before', 16, 'reserved bytes)'
    .ifgt  $, load_code - #1
    .error 'Code block too large'
    .endif
    .endm

*****************************************************************************
* Macro: check the size of the current code block.

    .defm  check_size
    .print 'Code block:', load_code - $, 'bytes free'
    .ifgt  $, load_code
    .error 'Code block too large'
    .endif
    .endm

*****************************************************************************

* Actual game code.

    copy "game.asm"

* Make sure that we've allocated sufficient space for the code.

    aorg
    .print 'Basic program:', basic_program_end - $, 'bytes free'
    .ifgt  $, basic_program_end
    .error 'Increase the assembly constant basic_program_length''
    .else
    .endif
    bss basic_program_end - $
