# CW_OPG_CFLAGS m4 macro -- this file is part of cwautomacros.
# Copyright (C) 2006, 2010 Carlo Wood <carlo@alinoe.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.
#
# As a special exception, the author gives unlimited permission to copy,
# distribute and modify the configure scripts that are the output of
# by a tool like autoconf when using these macros as input.  You need
# not follow the terms of the GNU General Public License when using or
# distributing such scripts, even though portions of the text of this
# file appears in them. The GNU General Public License (GPL) does govern
# all other use of the material that constitutes the cwautomacros project.

dnl CW_OPG_CFLAGS
dnl
dnl Add --enable-debug    (DEBUG, DOXYGEN_DEBUG),
dnl     --enable-optimize
dnl and --enable-profile
dnl options.
dnl
dnl This macro sets CFLAGS to include -g (or -ggdb on FreeBSD) when
dnl debugging is required, -O2 when optimization is required and
dnl appropriate warning flags.
dnl
dnl However, if CFLAGS already contains a -g* option then that is used
dnl instead of the default -g (-ggdb). If it contains a -O* option then
dnl that is used instead of -O2. Finally, if options are passed to
dnl the macro, then those are used instead of the default ones.
dnl
dnl Update CFLAGS and LDFLAGS accordingly.
dnl
dnl Further more, the following macros are set:
dnl
dnl CW_DEBUG_FLAGS	: Any -g* flags.
dnl CW_OPTIMISE_FLAGS	: Any -O* flags.
dnl CW_WARNING_FLAGS	: Any -W* flags.
dnl CW_STRIPPED_CFLAGS: Any other flags that were already in CFLAGS.
dnl
AC_DEFUN([CW_OPG_CFLAGS], [dnl
dnl Containers for the respective options.
m4_pattern_allow(CW_DEBUG_FLAGS)
m4_pattern_allow(CW_OPTIMISE_FLAGS)
m4_pattern_allow(CW_WARNING_FLAGS)
m4_pattern_allow(CW_STRIPPED_CFLAGS)
m4_pattern_allow(CW_DEFAULT_DEBUG_FLAGS)

# Add args to configure
AC_ARG_ENABLE(debug,         [  --enable-debug          build for debugging @<:@no@:>@], [cw_config_debug=$enableval], [cw_config_debug=])
AC_ARG_ENABLE(optimize,      [  --enable-optimize       do code optimization @<:@auto@:>@], [cw_config_optimize=$enableval], [cw_config_optimize=])
AC_ARG_ENABLE(profile,       [  --enable-profile        add profiling code @<:@no@:>@], [cw_config_profile=$enableval], [cw_config_profile=])

# Strip possible -g and -O commandline options from CFLAGS.
CW_DEBUG_FLAGS=
CW_OPTIMISE_FLAGS=
CW_WARNING_FLAGS=
CW_STRIPPED_CFLAGS=
for arg in $CFLAGS; do
case "$arg" in # (
-g*)
        CW_DEBUG_FLAGS="$CW_DEBUG_FLAGS $arg"
        ;; # (
-O*)
        CW_OPTIMISE_FLAGS="$CW_OPTIMISE_FLAGS $arg"
        ;; # (
-W*)	CW_WARNING_FLAGS="$CW_WARNING_FLAGS $arg"
	;; # (
*)
        CW_STRIPPED_CFLAGS="$CW_STRIPPED_CFLAGS $arg"
        ;;
esac
done

# Set various defaults, depending on other options.

if test x"$cw_config_optimize" = x"no"; then
    CW_OPTIMISE_FLAGS=""        # Explicit --disable-optimize, strip optimization even from CFLAGS environment variable.
fi

if test x"$enable_maintainer_mode" = x"yes"; then
  if test -z "$cw_config_optimize"; then
    cw_config_optimize=no          # --enable-maintainer-mode, set default to --disable-optimize.
  fi
  if test -z "$cw_config_debug"; then
    cw_config_debug=yes            # --enable-maintainer-mode, set default to --enable-debug.
  fi
fi

if test x"$cw_config_debug" = x"yes"; then
  if test -z "$cw_config_optimize"; then
    cw_config_optimize=no          # --enable-debug and no --enable-optimize, set default to --disable-optimize.
  fi
fi

dnl Find out which debugging options we need
AC_CANONICAL_HOST
case "$host" in
  *freebsd*) CW_DEFAULT_DEBUG_FLAGS=-ggdb ;; dnl FreeBSD needs -ggdb to include sourcefile:linenumber info in its object files.
  *) CW_DEFAULT_DEBUG_FLAGS=-g ;;
esac

# Handle cw_config_debug.
if test x"$cw_config_debug" = x"yes"; then
  CW_STRIPPED_CFLAGS="$CW_STRIPPED_CFLAGS -DDEBUG"
  DOXYGEN_DEBUG=DEBUG
  test -n "$CW_DEBUG_FLAGS" || CW_DEBUG_FLAGS="$CW_DEFAULT_DEBUG_FLAGS"
else
  DOXYGEN_DEBUG=
fi
AC_SUBST([DOXYGEN_DEBUG])

# Handle cw_config_optimize; when not explicitly set to "no", use user provided
# optimization flags, or -O2 when nothing was provided.
if test x"$cw_config_optimize" != x"no"; then
  test -n "$CW_OPTIMISE_FLAGS" || CW_OPTIMISE_FLAGS="-O2"
elif test "$ac_test_CFLAGS" != set; then
  # If CFLAGS was set by configure, reset CW_OPTIMISE_FLAGS.
  CW_OPTIMISE_FLAGS=
fi

# Handle cw_config_profile.
if test x"$cw_config_profile" = x"yes"; then
  CW_STRIPPED_CFLAGS="$CW_STRIPPED_CFLAGS -pg"
  LDFLAGS="$LDFLAGS -pg"
fi

# Choose warning options to use.
# If not in maintainer mode, use the warning options that were in CFLAGS.
# Otherwise, use those plus any passed to the macro, or if neither are
# given a default string - and then filter out incompatible warnings.
if test x"$enable_maintainer_mode" = x"yes"; then
  if test -z "$1" -a -z "$CW_WARNING_FLAGS"; then
    CW_WARNING_FLAGS="-W -Wall -Woverloaded-virtual -Wundef -Wpointer-arith -Wwrite-strings -Werror -Winline"
  else
    CW_WARNING_FLAGS="$CW_WARNING_FLAGS $1"
  fi
  AC_EGREP_CPP(Winline-broken, [
#if __GNUC__ < 3
  Winline-broken
#endif
  ],
     dnl -Winline is broken.
     [CW_WARNING_FLAGS="$(echo "$CW_WARNING_FLAGS" | sed -e 's/ -Winline//g')"],
     dnl -Winline is not broken. Remove -Werror when optimizing though.
     [if test -n "$CW_OPTIMISE_FLAGS"; then
        CW_WARNING_FLAGS="$(echo "$CW_WARNING_FLAGS" | sed -e 's/ -Werror//g')"
      fi]
  )
fi

# Reassemble CFLAGS with debug and optimization flags.
[CFLAGS=`echo "$CW_DEBUG_FLAGS $CW_WARNING_FLAGS $CW_OPTIMISE_FLAGS $CW_STRIPPED_CFLAGS" | sed -e 's/^ *//' -e 's/  */ /g' -e 's/ *$//'`]

dnl Put CFLAGS into the Makefile.
AC_SUBST(CFLAGS)
dnl Allow fine tuning if necessary, by putting the substituting the parts too.
AC_SUBST(CW_DEBUG_FLAGS)
AC_SUBST(CW_WARNING_FLAGS)
AC_SUBST(CW_OPTIMISE_FLAGS)
AC_SUBST(CW_STRIPPED_CFLAGS)
])
