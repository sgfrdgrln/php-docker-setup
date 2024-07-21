# If CFLAGS and CXXFLAGS are unset, default to empty.
# This is to tell automake not to include '-g' if C{XX,}FLAGS is not set.
# For more info - http://www.gnu.org/software/automake/manual/autoconf.html#C_002b_002b-Compiler
if test -z "$CXXFLAGS"; then
    CXXFLAGS=""
fi
if test -z "$CFLAGS"; then
    CFLAGS=""
fi

AC_PROG_CC
AC_PROG_CXX

dnl AC_PROG_CC_C99 is previously called in config.m4, but AC_PROG_CC resets CC
dnl so call it once more to ensure C99 remains enabled
m4_version_prereq([2.70],,[AC_PROG_CC_C99])

# Check that an appropriate C compiler is available.
# Note: BEGIN_IGNORE_DEPRECATIONS macro requires GCC 4.6+.
c_compiler="unknown"
AC_LANG_PUSH([C])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([
#if !(defined(__GNUC__) && !defined(__clang__) && !defined(__INTEL_COMPILER))
#error Not a supported GCC compiler
#endif
#if defined(__GNUC__)
#define GCC_VERSION (__GNUC__ * 10000 \
                     + __GNUC_MINOR__ * 100 \
                     + __GNUC_PATCHLEVEL__)
#if GCC_VERSION < 40600
#error Not a supported GCC compiler
#endif
#endif
])], [c_compiler="gcc"], [])

AC_COMPILE_IFELSE([AC_LANG_PROGRAM([
#if defined(__clang__)
#define CLANG_VERSION (__clang_major__ * 10000 \
                       + __clang_minor__ * 100 \
                       + __clang_patchlevel__)
#if CLANG_VERSION < 30300
#error Not a supported Clang compiler
#endif
#endif
])], [c_compiler="clang"], [])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([
#if !(defined(__SUNPRO_C))
#error Not a supported Sun compiler
#endif
])], [c_compiler="sun"], [])

AC_LANG_POP([C])

if test "$c_compiler" = "unknown"; then
    AC_MSG_ERROR([Compiler GCC >= 4.6 or Clang >= 3.3 is required for C compilation])
fi

AC_C_CONST
AC_C_INLINE
AC_C_TYPEOF
