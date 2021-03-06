# ===========================================================================
#        https://www.gnu.org/software/autoconf-archive/ax_var_pop.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_VAR_POPVALUE(VARIABLE)
#
# DESCRIPTION
#
#   Restores a variable's previous value. Compile, link and running tests
#   usually require the programmer to provide additional flags. However, it
#   is strongly recommended not to override flags defined by the user
#   through the configure command. AX_VAR_PUSHVALUE and AX_VAR_POPVALUE are
#   clean way to temporarily store a variable's value and restore it later,
#   using a stack-like behaviour. This macro supports nesting.
#
#   Example:
#
#     AX_VAR_PUSHVALUE([CXXFLAGS],["my test flags"])
#     perform some checks with CXXFLAGS...
#     CXXFLAGS value will be "my test flags"
#     AX_VAR_POPVALUE([CXXFLAGS])
#     CXXFLAGS is restored to its original value
#
# LICENSE
#
#   Copyright (c) 2015 Jorge Bellon <jbelloncastro@gmail.com>
#
#   This program is free software: you can redistribute it and/or modify it
#   under the terms of the GNU General Public License as published by the
#   Free Software Foundation, either version 3 of the License, or (at your
#   option) any later version.
#
#   This program is distributed in the hope that it will be useful, but
#   WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
#   Public License for more details.
#
#   You should have received a copy of the GNU General Public License along
#   with this program. If not, see <https://www.gnu.org/licenses/>.
#
#   As a special exception, the respective Autoconf Macro's copyright owner
#   gives unlimited permission to copy, distribute and modify the configure
#   scripts that are the output of Autoconf when processing the Macro. You
#   need not follow the terms of the GNU General Public License when using
#   or distributing such scripts, even though portions of the text of the
#   Macro appear in them. The GNU General Public License (GPL) does govern
#   all other use of the material that constitutes the Autoconf Macro.
#
#   This special exception to the GPL applies to versions of the Autoconf
#   Macro released by the Autoconf Archive. When you make and distribute a
#   modified version of the Autoconf Macro, you may extend this special
#   exception to the GPL to apply to your modified version as well.

#serial 3

# Main macros
AC_DEFUN([AX_VAR_PUSHVALUE],[
  increment([$1_counter])

  AS_VAR_PUSHDEF([variable],[$1]) dnl
  AS_VAR_PUSHDEF([backup],[save_$1_]$1_counter) dnl

  AS_VAR_SET(backup,$variable) dnl
  AS_VAR_SET(variable,["]m4_default($2,$variable)["]) dnl

  AS_VAR_POPDEF([variable]) dnl
  AS_VAR_POPDEF([backup]) dnl
])dnl AX_PUSH_VAR

AC_DEFUN([AX_VAR_POPVALUE],[
  AS_VAR_PUSHDEF([variable],[$1]) dnl
  AS_VAR_PUSHDEF([backup],[save_$1_]$1_counter) dnl

  AS_VAR_SET(variable,$backup) dnl

  decrement([$1_counter])
  AS_VAR_POPDEF([variable]) dnl
  AS_VAR_POPDEF([backup]) dnl
])dnl AX_POP_VAR

# -------------------------
# Auxiliary macro
# -------------------------
# increment(counter_name)
#
# Increment the value of a named counter.
# Initialize to 1 if not defined
# -------------------------
m4_define([increment],[dnl
  m4_ifdef([$1],dnl
    [m4_define([$1],m4_incr($1))],dnl
    [m4_define([$1],[1])]dnl
  )dnl
])dnl

# -------------------------
# Auxiliary macro
# -------------------------
# decrement(counter_name)
#
# Decrement the value of a named counter.
# Throws an error if counter not defined
# or value reaches zero.
# -------------------------
m4_define([decrement],[dnl
 m4_ifdef([$1],dnl
   [m4_if(m4_eval($1 > 0),
     [1],m4_define([$1],m4_decr($1)),dnl
     [m4_fatal([Missing call to AX_VAR_PUSHVALUE with var $1])]dnl
   )],dnl
   [m4_fatal([Missing call to AX_VAR_PUSHVALUE with var $1])])dnl
])dnl
