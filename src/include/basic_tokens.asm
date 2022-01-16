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
* Definitions of some relevant tokens and macros for programs in TI BASIC.
******************************************************************************

token_line_terminator   equ >00

token_rem               equ >9a
token_call              equ >9d
token_open              equ >9f

token_comma             equ >b3
token_colon             equ >b5
token_close_parenthesis equ >b6
token_open_parenthesis  equ >b7
token_colon             equ >b5
token_quoted_string     equ >c7
token_unquoted_string   equ >c8
token_hash              equ >fd

* Macro: insert the tokens for a given quoted string.
* IN #1: the string.
    .defm quoted_string
    byte token_quoted_string
    stri #1
    .endm

* Macro: insert the tokens for a given unquoted string.
* IN #1: the string.
    .defm unquoted_string
    byte token_unquoted_string
    stri #1
    .endm

* Macro: insert the tokens for a REM statement.
* IN #1: the comment, typically starting with a space.
    .defm rem
    byte token_rem
    text #1
    byte token_line_terminator
    .endm

* Macro: insert the tokens for a CALL statement without arguments.
* IN #1: the subroutine to call.
    .defm call0
    byte token_call
    .unquoted_string #1
    byte token_open_parenthesis
    byte token_close_parenthesis
    byte token_line_terminator
    .endm

* Macro: insert the tokens for a CALL statement with one unquoted argument.
* IN #1: the subroutine to call.
* IN #2: the argument.
    .defm call1
    byte token_call
    .unquoted_string #1
    byte token_open_parenthesis
    .unquoted_string #2
    byte token_close_parenthesis
    byte token_line_terminator
    .endm

* Macro: insert the tokens for a CALL statement with two unquoted arguments.
* IN #1: the subroutine to call.
* IN #2: the first argument.
* IN #3: the second argument.
    .defm call2
    byte token_call
    .unquoted_string #1
    byte token_open_parenthesis
    .unquoted_string #2
    byte token_comma
    .unquoted_string #3
    byte token_close_parenthesis
    byte token_line_terminator
    .endm

* Macro: insert the tokens for a CALL statement with three unquoted arguments.
* IN #1: the subroutine to call.
* IN #2: the first argument.
* IN #3: the second argument.
* IN #4: the third argument.
    .defm call3
    byte token_call
    .unquoted_string #1
    byte token_open_parenthesis
    .unquoted_string #2
    byte token_comma
    .unquoted_string #3
    byte token_comma
    .unquoted_string #4
    byte token_close_parenthesis
    byte token_line_terminator
    .endm

* Macro: insert the tokens for a CALL statement with four unquoted arguments.
* IN #1: the subroutine to call.
* IN #2: the first argument.
* IN #3: the second argument.
* IN #4: the third argument.
* IN #5: the fourth argument.
    .defm call4
    byte token_call
    .unquoted_string #1
    byte token_open_parenthesis
    .unquoted_string #2
    byte token_comma
    .unquoted_string #3
    byte token_comma
    .unquoted_string #4
    byte token_comma
    .unquoted_string #5
    byte token_close_parenthesis
    byte token_line_terminator
    .endm
