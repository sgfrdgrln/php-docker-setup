dnl Determine the base directory used for subsequent m4_include calls
m4_define(PHP_MONGODB_BASEDIR, esyscmd(printf %s "$(dirname "__file__")"))

PHP_ARG_ENABLE([mongodb],
               [whether to enable MongoDB support],
               [AS_HELP_STRING([--enable-mongodb],
                               [Enable MongoDB support])])

if test "$PHP_MONGODB" != "no"; then
  dnl Common includes for both bundled and system builds
  m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/m4/php_mongodb.m4)
  m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/m4/pkg.m4)

  PKG_PROG_PKG_CONFIG

  dnl Enable C99 (required for libmongoc 1.24+). On Autoconf 2.70+, this will
  dnl already have been done when AC_PROG_CC is called from configure.ac.
  m4_version_prereq([2.70],,[AC_PROG_CC_C99])

  if test "$ac_cv_prog_cc_c99" = no; then
    AC_MSG_ERROR([Compiler does not support C99])
  fi

  dnl Check PHP version is compatible with this extension
  AC_MSG_CHECKING([PHP version])

  if test -z "${PHP_VERSION_ID}"; then
    if test -z "$PHP_CONFIG"; then
      AC_MSG_ERROR([php-config not found])
    fi

    PHP_MONGODB_PHP_VERSION=`${PHP_CONFIG} --version`
    PHP_MONGODB_PHP_VERSION_ID=`${PHP_CONFIG} --vernum`
  else
    PHP_MONGODB_PHP_VERSION="${PHP_VERSION}"
    PHP_MONGODB_PHP_VERSION_ID="${PHP_VERSION_ID}"
  fi

  AC_MSG_RESULT($PHP_MONGODB_PHP_VERSION)

  if test "$PHP_MONGODB_PHP_VERSION_ID" -lt "70400"; then
    AC_MSG_ERROR([not supported. Need a PHP version >= 7.4.0 (found $PHP_MONGODB_PHP_VERSION)])
  fi

  PHP_MONGODB_STD_CFLAGS=""
  PHP_MONGODB_DEV_CFLAGS=""
  PHP_MONGODB_COVERAGE_CFLAGS=""

  PHP_ARG_ENABLE([mongodb-developer-flags],
                 [whether to enable developer build flags],
                 [AS_HELP_STRING([--enable-mongodb-developer-flags],
                                 [MongoDB: Enable developer flags [default=no]])],
                 [no],
                 [no])
  PHP_MONGODB_VALIDATE_ARG([PHP_MONGODB_DEVELOPER_FLAGS], [yes no])

  if test "$PHP_MONGODB_DEVELOPER_FLAGS" = "yes"; then
    PHP_MONGODB_STD_CFLAGS="-g -O0 -Wall"

    dnl Warn about functions which might be candidates for format attributes
    AX_CHECK_COMPILE_FLAG(-Wmissing-format-attribute,       PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wmissing-format-attribute"     ,, -Werror)
    dnl Avoid duplicating values for an enum
    AX_CHECK_COMPILE_FLAG(-Wduplicate-enum,                 PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wduplicate-enum"               ,, -Werror)
    dnl Warns on mismatches between #ifndef and #define header guards
    AX_CHECK_COMPILE_FLAG(-Wheader-guard,                   PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wheader-guard"                 ,, -Werror)
    dnl logical not of a non-boolean expression
    AX_CHECK_COMPILE_FLAG(-Wlogical-not-parentheses,        PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wlogical-not-parentheses"      ,, -Werror)
    dnl Warn about suspicious uses of logical operators in expressions
    AX_CHECK_COMPILE_FLAG(-Wlogical-op,                     PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wlogical-op"                   ,, -Werror)
    dnl memory error detector.
    dnl FIXME: -fsanitize=address,undefined for clang. The AX_CHECK_COMPILE_FLAG macro isn't happy about that string :(
    AX_CHECK_COMPILE_FLAG(-fsanitize-address,               PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -fsanitize-address"             ,, -Werror)
    dnl Enable frame debugging
    AX_CHECK_COMPILE_FLAG(-fno-omit-frame-pointer,          PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -fno-omit-frame-pointer"        ,, -Werror)
    dnl Make sure we don't optimize calls
    AX_CHECK_COMPILE_FLAG(-fno-optimize-sibling-calls,      PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -fno-optimize-sibling-calls"    ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wlogical-op-parentheses,         PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wlogical-op-parentheses"       ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wpointer-bool-conversion,        PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wpointer-bool-conversion"      ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wbool-conversion,                PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wbool-conversion"              ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wloop-analysis,                  PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wloop-analysis"                ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wsizeof-array-argument,          PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wsizeof-array-argument"        ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wstring-conversion,              PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wstring-conversion"            ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wno-variadic-macros,             PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wno-variadic-macros"           ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wno-sign-compare,                PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wno-sign-compare"              ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-fstack-protector,                PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -fstack-protector"              ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-fno-exceptions,                  PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -fno-exceptions"                ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wformat-security,                PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wformat-security"              ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wformat-nonliteral,              PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wformat-nonliteral"            ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Winit-self,                      PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Winit-self"                    ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wwrite-strings,                  PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wwrite-strings"                ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wenum-compare,                   PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wenum-compare"                 ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wempty-body,                     PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wempty-body"                   ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wparentheses,                    PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wparentheses"                  ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wmaybe-uninitialized,            PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wmaybe-uninitialized"          ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wimplicit-fallthrough,           PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wimplicit-fallthrough"         ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Werror,                          PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Werror"                        ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wextra,                          PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wextra"                        ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wno-unused-parameter,            PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wno-unused-parameter"          ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wno-unused-but-set-variable,     PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wno-unused-but-set-variable"   ,, -Werror)
    AX_CHECK_COMPILE_FLAG(-Wno-missing-field-initializers,  PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wno-missing-field-initializers",, -Werror)

    if test "$PHP_MONGODB_PHP_VERSION_ID" -ge "80108"; then
      AX_CHECK_COMPILE_FLAG(-Wstrict-prototypes, PHP_MONGODB_DEV_CFLAGS="$PHP_MONGODB_DEV_CFLAGS -Wstrict-prototypes",, -Werror)
    fi
  fi


  PHP_ARG_ENABLE([mongodb-coverage],
                 [whether to enable code coverage],
                 [AS_HELP_STRING([--enable-mongodb-coverage],
                                 [MongoDB: Enable developer code coverage information [default=no]])],
                 [no],
                 [no])
  PHP_MONGODB_VALIDATE_ARG([PHP_MONGODB_COVERAGE], [yes no])

  if test "$PHP_MONGODB_COVERAGE" = "yes"; then
    if test "$ext_shared" != "yes"; then
      AC_MSG_ERROR(code coverage is not supported for static builds)
    fi

    PHP_MONGODB_COVERAGE_CFLAGS="--coverage -g"
    MONGODB_SHARED_LIBADD="$MONGODB_SHARED_LIBADD --coverage"
  fi

  PHP_MONGODB_CFLAGS="$PHP_MONGODB_STD_CFLAGS $PHP_MONGODB_DEV_CFLAGS $PHP_MONGODB_COVERAGE_CFLAGS"

  PHP_MONGODB_SOURCES="\
    php_phongo.c \
    src/phongo_apm.c \
    src/phongo_bson.c \
    src/phongo_bson_encode.c \
    src/phongo_client.c \
    src/phongo_compat.c \
    src/phongo_error.c \
    src/phongo_execute.c \
    src/phongo_ini.c \
    src/phongo_log.c \
    src/phongo_util.c \
    src/BSON/Binary.c \
    src/BSON/BinaryInterface.c \
    src/BSON/Document.c \
    src/BSON/Iterator.c \
    src/BSON/DBPointer.c \
    src/BSON/Decimal128.c \
    src/BSON/Decimal128Interface.c \
    src/BSON/Int64.c \
    src/BSON/Javascript.c \
    src/BSON/JavascriptInterface.c \
    src/BSON/MaxKey.c \
    src/BSON/MaxKeyInterface.c \
    src/BSON/MinKey.c \
    src/BSON/MinKeyInterface.c \
    src/BSON/ObjectId.c \
    src/BSON/ObjectIdInterface.c \
    src/BSON/PackedArray.c \
    src/BSON/Persistable.c \
    src/BSON/Regex.c \
    src/BSON/RegexInterface.c \
    src/BSON/Serializable.c \
    src/BSON/Symbol.c \
    src/BSON/Timestamp.c \
    src/BSON/TimestampInterface.c \
    src/BSON/Type.c \
    src/BSON/Undefined.c \
    src/BSON/Unserializable.c \
    src/BSON/UTCDateTime.c \
    src/BSON/UTCDateTimeInterface.c \
    src/BSON/functions.c \
    src/MongoDB/BulkWrite.c \
    src/MongoDB/ClientEncryption.c \
    src/MongoDB/Command.c \
    src/MongoDB/Cursor.c \
    src/MongoDB/CursorId.c \
    src/MongoDB/CursorInterface.c \
    src/MongoDB/Manager.c \
    src/MongoDB/Query.c \
    src/MongoDB/ReadConcern.c \
    src/MongoDB/ReadPreference.c \
    src/MongoDB/Server.c \
    src/MongoDB/ServerApi.c \
    src/MongoDB/ServerDescription.c \
    src/MongoDB/Session.c \
    src/MongoDB/TopologyDescription.c \
    src/MongoDB/WriteConcern.c \
    src/MongoDB/WriteConcernError.c \
    src/MongoDB/WriteError.c \
    src/MongoDB/WriteResult.c \
    src/MongoDB/Exception/AuthenticationException.c \
    src/MongoDB/Exception/BulkWriteException.c \
    src/MongoDB/Exception/CommandException.c \
    src/MongoDB/Exception/ConnectionException.c \
    src/MongoDB/Exception/ConnectionTimeoutException.c \
    src/MongoDB/Exception/EncryptionException.c \
    src/MongoDB/Exception/Exception.c \
    src/MongoDB/Exception/ExecutionTimeoutException.c \
    src/MongoDB/Exception/InvalidArgumentException.c \
    src/MongoDB/Exception/LogicException.c \
    src/MongoDB/Exception/RuntimeException.c \
    src/MongoDB/Exception/ServerException.c \
    src/MongoDB/Exception/SSLConnectionException.c \
    src/MongoDB/Exception/UnexpectedValueException.c \
    src/MongoDB/Exception/WriteException.c \
    src/MongoDB/Monitoring/CommandFailedEvent.c \
    src/MongoDB/Monitoring/CommandStartedEvent.c \
    src/MongoDB/Monitoring/CommandSubscriber.c \
    src/MongoDB/Monitoring/CommandSucceededEvent.c \
    src/MongoDB/Monitoring/LogSubscriber.c \
    src/MongoDB/Monitoring/SDAMSubscriber.c \
    src/MongoDB/Monitoring/Subscriber.c \
    src/MongoDB/Monitoring/ServerChangedEvent.c \
    src/MongoDB/Monitoring/ServerClosedEvent.c \
    src/MongoDB/Monitoring/ServerHeartbeatFailedEvent.c \
    src/MongoDB/Monitoring/ServerHeartbeatStartedEvent.c \
    src/MongoDB/Monitoring/ServerHeartbeatSucceededEvent.c \
    src/MongoDB/Monitoring/ServerOpeningEvent.c \
    src/MongoDB/Monitoring/TopologyChangedEvent.c \
    src/MongoDB/Monitoring/TopologyClosedEvent.c \
    src/MongoDB/Monitoring/TopologyOpeningEvent.c \
    src/MongoDB/Monitoring/functions.c \
  "

  PHP_ARG_WITH([mongodb-system-libs],
               [whether to compile against system libraries instead of bundled],
               [AS_HELP_STRING([--with-mongodb-system-libs=@<:@yes/no@:>@],
                               [MongoDB: Use system libraries for libbson, libmongoc, and libmongocrypt [default=no]])],
               [no],
               [no])
  PHP_MONGODB_VALIDATE_ARG([PHP_MONGODB_SYSTEM_LIBS], [yes no])

  PHP_ARG_WITH([libbson],
               [whether to use system libbson],
               [AS_HELP_STRING([--with-libbson=@<:@yes/no@:>@],
                               [MongoDB: Use system libbson (deprecated for --with-mongodb-system-libs) [default=no]])],
               [no],
               [no])
  PHP_MONGODB_VALIDATE_ARG([PHP_LIBBSON], [yes no])

  PHP_ARG_WITH([libmongoc],
               [whether to use system libmongoc],
               [AS_HELP_STRING([--with-libmongoc=@<:@yes/no@:>@],
                               [MongoDB: Use system libmongoc (deprecated for --with-mongodb-system-libs) [default=no]])],
               [no],
               [no])
  PHP_MONGODB_VALIDATE_ARG([PHP_LIBMONGOC], [yes no])

  PHP_ARG_WITH([mongodb-client-side-encryption],
               [whether to enable client-side encryption],
               [AS_HELP_STRING([--with-mongodb-client-side-encryption=@<:@auto/yes/no@:>@],
                               [MongoDB: Enable client-side encryption [default=auto]])],
               [auto],
               [no])
  PHP_MONGODB_VALIDATE_ARG([PHP_MONGODB_CLIENT_SIDE_ENCRYPTION], [auto yes no])

  if test "$PHP_LIBBSON" != "no"; then
    AC_MSG_WARN(Using --with-libbson is deprecated and will be removed in a future version. Please use --with-system-libs instead)

    if test "$PHP_LIBMONGOC" = "no"; then
      AC_MSG_ERROR(Cannot use system libbson and bundled libmongoc)
    fi

    PHP_MONGODB_SYSTEM_LIBS="yes"
  fi

  if test "$PHP_LIBMONGOC" != "no"; then
    AC_MSG_WARN(Using --with-libmongoc is deprecated and will be removed in a future version. Please use --with-system-libs instead)

    if test "$PHP_LIBBSON" = "no"; then
      AC_MSG_ERROR(Cannot use system libmongoc and bundled libbson)
    fi

    PHP_MONGODB_SYSTEM_LIBS="yes"
  fi

  PHP_MONGODB_BSON_VERSION_STRING="None"
  PHP_MONGODB_MONGOC_VERSION_STRING="None"
  PHP_MONGODB_MONGOCRYPT_VERSION_STRING="None"

  if test "$PHP_MONGODB_SYSTEM_LIBS" != "no"; then
    PKG_CHECK_MODULES([PHP_MONGODB_BSON], [libbson-1.0 >= 1.28.0], [
      PHP_MONGODB_BSON_VERSION=`$PKG_CONFIG libbson-1.0 --modversion`
      PHP_MONGODB_BSON_VERSION_STRING="System ($PHP_MONGODB_BSON_VERSION)"

      PHP_MONGODB_CFLAGS="$PHP_MONGODB_CFLAGS $PHP_MONGODB_BSON_CFLAGS"
      PHP_EVAL_LIBLINE($PHP_MONGODB_BSON_LIBS, MONGODB_SHARED_LIBADD)
      AC_DEFINE(HAVE_SYSTEM_LIBBSON, 1, [Use system libbson])
    ],[
      AC_MSG_ERROR([Could not find system library for libbson >= 1.28.0])
    ])

    PKG_CHECK_MODULES([PHP_MONGODB_MONGOC], [libmongoc-1.0 >= 1.28.0], [
      PHP_MONGODB_BSON_VERSION=`$PKG_CONFIG libbson-1.0 --modversion`
      PHP_MONGODB_BSON_VERSION_STRING="System ($PHP_MONGODB_BSON_VERSION)"

      PHP_MONGODB_CFLAGS="$PHP_MONGODB_CFLAGS $PHP_MONGODB_MONGOC_CFLAGS"
      PHP_EVAL_LIBLINE($PHP_MONGODB_MONGOC_LIBS, MONGODB_SHARED_LIBADD)
      AC_DEFINE(HAVE_SYSTEM_LIBMONGOC, 1, [Use system libmongoc])
    ],[
      AC_MSG_ERROR(Could not find system library for libmongoc >= 1.28.0)
    ])

    if test "$PHP_MONGODB_CLIENT_SIDE_ENCRYPTION" != "no"; then
      PKG_CHECK_MODULES([PHP_MONGODB_MONGOCRYPT], [libmongocrypt >= 1.9.1], [
        PHP_MONGODB_MONGOCRYPT_VERSION=`$PKG_CONFIG libmongocrypt --modversion`
        PHP_MONGODB_MONGOCRYPT_VERSION_STRING="System ($PHP_MONGODB_MONGOCRYPT_VERSION)"

        PHP_MONGODB_CFLAGS="$PHP_MONGODB_CFLAGS $PHP_MONGODB_MONGOCRYPT_CFLAGS"
        PHP_EVAL_LIBLINE($PHP_MONGODB_MONGOCRYPT_LIBS, MONGODB_SHARED_LIBADD)
        AC_DEFINE(HAVE_SYSTEM_LIBMONGOCRYPT, 1, [Use system libmongocrypt])
      ],[
        AC_MSG_ERROR(Could not find system library for libmongocrypt >= 1.9.1)
      ])
    fi
  fi

  if test "$PHP_MONGODB_SYSTEM_LIBS" = "no"; then
    PHP_MONGODB_BUNDLED_CFLAGS="$PHP_MONGODB_STD_CFLAGS -DBSON_COMPILATION -DMONGOC_COMPILATION"

    dnl CheckUtf8Proc.m4 will modify this when using bundled utf8proc
    PHP_MONGODB_UTF8PROC_CFLAGS=""

    dnl CheckCompression.m4 will modify this when using bundled zlib
    PHP_MONGODB_ZLIB_CFLAGS=""

    dnl Endian.m4 will modify this when using bundled libmongocrypt
    PHP_MONGODB_LIBMONGOCRYPT_CFLAGS=""

    dnl Save CPPFLAGS, which PlatformFlags.m4 modifies for subsequent M4 scripts
    old_CPPFLAGS="$CPPFLAGS"

    dnl Avoid using AC_CONFIG_MACRO_DIR, which might conflict with PHP
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/m4/ax_check_compile_flag.m4)
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/m4/ax_prototype.m4)
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/m4/ax_prototype_accept.m4)
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/m4/ax_pthread.m4)

    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/CheckCompiler.m4)
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/CheckHost.m4)
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/PlatformFlags.m4)

    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/libbson/CheckAtomics.m4)
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/libbson/CheckHeaders.m4)
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/libbson/Endian.m4)
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/libbson/FindDependencies.m4)
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/libbson/Versions.m4)

    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/libmongoc/CheckCompression.m4)
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/libmongoc/CheckResolv.m4)
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/libmongoc/CheckSasl.m4)
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/libmongoc/CheckSSL.m4)
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/libmongoc/CheckUtf8Proc.m4)
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/libmongoc/Endian.m4)
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/libmongoc/FindDependencies.m4)
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/libmongoc/Versions.m4)
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/libmongoc/WeakSymbols.m4)

    dnl This include modifies the value of $PHP_MONGODB_CLIENT_SIDE_ENCRYPTION to "yes"
    dnl or "no" depending on whether dependencies for libmongocrypt are fulfilled
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/libmongocrypt/CheckSSL.m4)
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/libmongocrypt/Endian.m4)
    m4_include(PHP_MONGODB_BASEDIR/scripts/autotools/libmongocrypt/Version.m4)

    dnl Restore CPPFLAGS once all M4 scripts have executed
    CPPFLAGS="$old_CPPFLAGS"

    PHP_MONGODB_BSON_VERSION_STRING="Bundled ($libbson_VERSION_FULL)"
    PHP_MONGODB_MONGOC_VERSION_STRING="Bundled ($libmongoc_VERSION_FULL)"

    AC_SUBST(BSON_EXTRA_ALIGN, 0)
    AC_SUBST(BSON_OS, 1)

    AC_SUBST(MONGOC_NO_AUTOMATIC_GLOBALS, 1)
    AC_SUBST(MONGOC_ENABLE_MONGODB_AWS_AUTH, 0)
    AC_SUBST(MONGOC_ENABLE_RDTSCP, 0)
    AC_SUBST(MONGOC_ENABLE_SHM_COUNTERS, 0)
    AC_SUBST(MONGOC_TRACE, 1)

    dnl Assignments for metadata handshake. Leave CFLAGS/LDFLAGS empty as they
    dnl would likely cause platform info (PHP version) to be truncated. We can
    dnl consider restoring CFLAGS/LDFLAGS once CDRIVER-3134 is resolved.
    AC_SUBST(MONGOC_CC, [$CC])
    AC_SUBST(MONGOC_USER_SET_CFLAGS, [])
    AC_SUBST(MONGOC_USER_SET_LDFLAGS, [])

    if test "$PHP_MONGODB_CLIENT_SIDE_ENCRYPTION" = "yes"; then
      AC_SUBST(MONGOC_ENABLE_CLIENT_SIDE_ENCRYPTION, 1)
    else
      AC_SUBST(MONGOC_ENABLE_CLIENT_SIDE_ENCRYPTION, 0)
    fi

    if test "$PHP_MONGODB_DEVELOPER_FLAGS" = "yes"; then
      AC_SUBST(MONGOC_ENABLE_DEBUG_ASSERTIONS, 1)
    else
      AC_SUBST(MONGOC_ENABLE_DEBUG_ASSERTIONS, 0)
    fi

    dnl Sources below are updated by scripts/update-submodule-sources.php
    PHP_MONGODB_COMMON_SOURCES="common-b64.c common-md5.c common-thread.c"
    PHP_MONGODB_KMS_MESSAGE_SOURCES="hexlify.c kms_azure_request.c kms_b64.c kms_caller_identity_request.c kms_crypto_apple.c kms_crypto_libcrypto.c kms_crypto_none.c kms_crypto_windows.c kms_decrypt_request.c kms_encrypt_request.c kms_gcp_request.c kms_kmip_reader_writer.c kms_kmip_request.c kms_kmip_response.c kms_kmip_response_parser.c kms_kv_list.c kms_message.c kms_port.c kms_request.c kms_request_opt.c kms_request_str.c kms_response.c kms_response_parser.c sort.c"
    PHP_MONGODB_BSON_SOURCES="bcon.c bson-atomic.c bson.c bson-clock.c bson-context.c bson-decimal128.c bson-error.c bson-iso8601.c bson-iter.c bson-json.c bson-keys.c bson-md5.c bson-memory.c bson-oid.c bson-reader.c bson-string.c bson-timegm.c bson-utf8.c bson-value.c bson-version-functions.c bson-writer.c"
    PHP_MONGODB_JSONSL_SOURCES="jsonsl.c"
    PHP_MONGODB_MONGOC_SOURCES="mcd-azure.c mcd-nsinfo.c mcd-rpc.c mongoc-aggregate.c mongoc-apm.c mongoc-array.c mongoc-async.c mongoc-async-cmd.c mongoc-buffer.c mongoc-bulk-operation.c mongoc-bulkwrite.c mongoc-change-stream.c mongoc-client.c mongoc-client-pool.c mongoc-client-session.c mongoc-client-side-encryption.c mongoc-cluster-aws.c mongoc-cluster.c mongoc-cluster-cyrus.c mongoc-cluster-sasl.c mongoc-cluster-sspi.c mongoc-cmd.c mongoc-collection.c mongoc-compression.c mongoc-counters.c mongoc-crypt.c mongoc-crypto.c mongoc-crypto-cng.c mongoc-crypto-common-crypto.c mongoc-crypto-openssl.c mongoc-cursor-array.c mongoc-cursor.c mongoc-cursor-change-stream.c mongoc-cursor-cmd.c mongoc-cursor-cmd-deprecated.c mongoc-cursor-find.c mongoc-cursor-find-cmd.c mongoc-cursor-find-opquery.c mongoc-cursor-legacy.c mongoc-cyrus.c mongoc-database.c mongoc-deprioritized-servers.c mongoc-error.c mongoc-find-and-modify.c mongoc-flags.c mongoc-generation-map.c mongoc-gridfs-bucket.c mongoc-gridfs-bucket-file.c mongoc-gridfs.c mongoc-gridfs-file.c mongoc-gridfs-file-list.c mongoc-gridfs-file-page.c mongoc-handshake.c mongoc-host-list.c mongoc-http.c mongoc-index.c mongoc-init.c mongoc-interrupt.c mongoc-libressl.c mongoc-linux-distro-scanner.c mongoc-list.c mongoc-log.c mongoc-matcher.c mongoc-matcher-op.c mongoc-memcmp.c mongoc-ocsp-cache.c mongoc-opcode.c mongoc-openssl.c mongoc-optional.c mongoc-opts.c mongoc-opts-helpers.c mongoc-queue.c mongoc-rand-cng.c mongoc-rand-common-crypto.c mongoc-rand-openssl.c mongoc-read-concern.c mongoc-read-prefs.c mongoc-rpc.c mongoc-sasl.c mongoc-scram.c mongoc-secure-channel.c mongoc-secure-transport.c mongoc-server-api.c mongoc-server-description.c mongoc-server-monitor.c mongoc-server-stream.c mongoc-set.c mongoc-shared.c mongoc-socket.c mongoc-ssl.c mongoc-sspi.c mongoc-stream-buffered.c mongoc-stream.c mongoc-stream-file.c mongoc-stream-gridfs.c mongoc-stream-gridfs-download.c mongoc-stream-gridfs-upload.c mongoc-stream-socket.c mongoc-stream-tls.c mongoc-stream-tls-libressl.c mongoc-stream-tls-openssl-bio.c mongoc-stream-tls-openssl.c mongoc-stream-tls-secure-channel.c mongoc-stream-tls-secure-transport.c mongoc-timeout.c mongoc-topology-background-monitoring.c mongoc-topology.c mongoc-topology-description-apm.c mongoc-topology-description.c mongoc-topology-scanner.c mongoc-ts-pool.c mongoc-uri.c mongoc-util.c mongoc-version-functions.c mongoc-write-command.c mongoc-write-concern.c service-gcp.c"
    PHP_MONGODB_UTF8PROC_SOURCES="utf8proc.c"
    PHP_MONGODB_ZLIB_SOURCES="adler32.c compress.c crc32.c deflate.c gzclose.c gzlib.c gzread.c gzwrite.c infback.c inffast.c inflate.c inftrees.c trees.c uncompr.c zutil.c"

    PHP_MONGODB_ADD_SOURCES([src/libmongoc/src/common/], $PHP_MONGODB_COMMON_SOURCES, $PHP_MONGODB_BUNDLED_CFLAGS)
    PHP_MONGODB_ADD_SOURCES([src/libmongoc/src/libbson/src/bson/], $PHP_MONGODB_BSON_SOURCES, $PHP_MONGODB_BUNDLED_CFLAGS)
    PHP_MONGODB_ADD_SOURCES([src/libmongoc/src/libbson/src/jsonsl/], $PHP_MONGODB_JSONSL_SOURCES, $PHP_MONGODB_BUNDLED_CFLAGS)
    PHP_MONGODB_ADD_SOURCES([src/libmongoc/src/libmongoc/src/mongoc/], $PHP_MONGODB_MONGOC_SOURCES, $PHP_MONGODB_BUNDLED_CFLAGS)

    PHP_MONGODB_ADD_INCLUDE([src/libmongoc/src/common/])
    PHP_MONGODB_ADD_INCLUDE([src/libmongoc/src/uthash/])
    PHP_MONGODB_ADD_INCLUDE([src/libmongoc/src/libbson/src/])
    PHP_MONGODB_ADD_INCLUDE([src/libmongoc/src/libbson/src/jsonsl/])
    PHP_MONGODB_ADD_INCLUDE([src/libmongoc/src/libmongoc/src/])

    PHP_MONGODB_ADD_BUILD_DIR([src/libmongoc/src/common/])
    PHP_MONGODB_ADD_BUILD_DIR([src/libmongoc/src/libbson/src/bson/])
    PHP_MONGODB_ADD_BUILD_DIR([src/libmongoc/src/libbson/src/jsonsl/])
    PHP_MONGODB_ADD_BUILD_DIR([src/libmongoc/src/libmongoc/src/mongoc/])

    dnl If compiling without libmongocrypt, use kms_message sources bundled with libmongoc.
    dnl If compiling with libmongocrypt, kms_message bundled with libmongocrypt is used as it is most likely newer.
    if test "$PHP_MONGODB_CLIENT_SIDE_ENCRYPTION" != "yes" && test "$PHP_MONGODB_SSL" != "no"; then
      AC_SUBST(MONGOC_ENABLE_MONGODB_AWS_AUTH, 1)
      PHP_MONGODB_ADD_SOURCES([src/libmongoc/src/kms-message/src/], $PHP_MONGODB_KMS_MESSAGE_SOURCES, $PHP_MONGODB_BUNDLED_CFLAGS)
      PHP_MONGODB_ADD_INCLUDE([src/libmongoc/src/kms-message/src/])
      PHP_MONGODB_ADD_BUILD_DIR([src/libmongoc/src/kms-message/src/])
    fi

    dnl TODO: Use $ext_srcdir if we can move this after PHP_NEW_EXTENSION
    ac_config_dir=PHP_EXT_SRCDIR(mongodb)

    AC_CONFIG_FILES([
      ${ac_config_dir}/src/libmongoc/src/common/common-config.h
      ${ac_config_dir}/src/libmongoc/src/libbson/src/bson/bson-config.h
      ${ac_config_dir}/src/libmongoc/src/libbson/src/bson/bson-version.h
      ${ac_config_dir}/src/libmongoc/src/libmongoc/src/mongoc/mongoc-config.h
      ${ac_config_dir}/src/libmongoc/src/libmongoc/src/mongoc/mongoc-version.h
    ])

    if test "x$bundled_utf8proc" = "xyes"; then
      PHP_MONGODB_UTF8PROC_CFLAGS="$PHP_MONGODB_BUNDLED_CFLAGS $PHP_MONGODB_UTF8PROC_CFLAGS"
      PHP_MONGODB_ADD_SOURCES([src/libmongoc/src/utf8proc-2.8.0/], $PHP_MONGODB_UTF8PROC_SOURCES, $PHP_MONGODB_UTF8PROC_CFLAGS)
      PHP_MONGODB_ADD_INCLUDE([src/libmongoc/src/utf8proc-2.8.0/])
      PHP_MONGODB_ADD_BUILD_DIR([src/libmongoc/src/utf8proc-2.8.0/])
    fi

    if test "x$bundled_zlib" = "xyes"; then
      PHP_MONGODB_ZLIB_CFLAGS="$PHP_MONGODB_BUNDLED_CFLAGS $PHP_MONGODB_ZLIB_CFLAGS"
      PHP_MONGODB_ADD_SOURCES([src/libmongoc/src/zlib-1.2.13/], $PHP_MONGODB_ZLIB_SOURCES, $PHP_MONGODB_ZLIB_CFLAGS)
      PHP_MONGODB_ADD_INCLUDE([src/libmongoc/src/zlib-1.2.13/])
      PHP_MONGODB_ADD_BUILD_DIR([src/libmongoc/src/zlib-1.2.13/])
      AC_CONFIG_FILES([${ac_config_dir}/src/libmongoc/src/zlib-1.2.13/zconf.h])
    fi

    if test "$PHP_MONGODB_CLIENT_SIDE_ENCRYPTION" = "yes"; then
      PHP_MONGODB_LIBMONGOCRYPT_CFLAGS="$PHP_MONGODB_BUNDLED_CFLAGS $PHP_MONGODB_LIBMONGOCRYPT_CFLAGS -DKMS_MSG_STATIC -DMLIB_USER"

      PHP_MONGODB_MONGOCRYPT_VERSION_STRING="Bundled ($MONGOCRYPT_BUILD_VERSION)"

      dnl Since libmongocrypt adds kms-message, we can enable AWS auth in this case
      AC_SUBST(MONGOC_ENABLE_MONGODB_AWS_AUTH, 1)
      AC_SUBST(MONGOCRYPT_ENABLE_TRACE, 1)

      dnl Sources below are updated by scripts/update-submodule-sources.php
      PHP_MONGODB_MONGOCRYPT_SOURCES="mc-array.c mc-efc.c mc-fle2-encryption-placeholder.c mc-fle2-find-equality-payload.c mc-fle2-find-equality-payload-v2.c mc-fle2-find-range-payload.c mc-fle2-find-range-payload-v2.c mc-fle2-insert-update-payload.c mc-fle2-insert-update-payload-v2.c mc-fle2-payload-iev.c mc-fle2-payload-iev-v2.c mc-fle2-payload-uev.c mc-fle2-payload-uev-common.c mc-fle2-payload-uev-v2.c mc-fle2-rfds.c mc-range-edge-generation.c mc-range-encoding.c mc-range-mincover.c mc-rangeopts.c mc-reader.c mc-tokens.c mc-writer.c mongocrypt-binary.c mongocrypt-buffer.c mongocrypt.c mongocrypt-cache.c mongocrypt-cache-collinfo.c mongocrypt-cache-key.c mongocrypt-cache-oauth.c mongocrypt-ciphertext.c mongocrypt-crypto.c mongocrypt-ctx.c mongocrypt-ctx-datakey.c mongocrypt-ctx-decrypt.c mongocrypt-ctx-encrypt.c mongocrypt-ctx-rewrap-many-datakey.c mongocrypt-endpoint.c mongocrypt-kek.c mongocrypt-key-broker.c mongocrypt-key.c mongocrypt-kms-ctx.c mongocrypt-log.c mongocrypt-marking.c mongocrypt-opts.c mongocrypt-status.c mongocrypt-traverse-util.c mongocrypt-util.c"
      PHP_MONGODB_MONGOCRYPT_CRYPTO_SOURCES="cng.c commoncrypto.c libcrypto.c none.c"
      PHP_MONGODB_MONGOCRYPT_OS_POSIX_SOURCES="os_dll.c os_mutex.c"
      PHP_MONGODB_MONGOCRYPT_OS_WIN_SOURCES="os_dll.c os_mutex.c"
      PHP_MONGODB_MONGOCRYPT_KMS_MESSAGE_SOURCES="hexlify.c kms_azure_request.c kms_b64.c kms_caller_identity_request.c kms_crypto_apple.c kms_crypto_libcrypto.c kms_crypto_none.c kms_crypto_windows.c kms_decrypt_request.c kms_encrypt_request.c kms_gcp_request.c kms_kmip_reader_writer.c kms_kmip_request.c kms_kmip_response.c kms_kmip_response_parser.c kms_kv_list.c kms_message.c kms_port.c kms_request.c kms_request_opt.c kms_request_str.c kms_response.c kms_response_parser.c sort.c"

      PHP_MONGODB_ADD_SOURCES([src/libmongocrypt/src/], $PHP_MONGODB_MONGOCRYPT_SOURCES, $PHP_MONGODB_LIBMONGOCRYPT_CFLAGS)
      PHP_MONGODB_ADD_SOURCES([src/libmongocrypt/src/crypto/], $PHP_MONGODB_MONGOCRYPT_CRYPTO_SOURCES, $PHP_MONGODB_LIBMONGOCRYPT_CFLAGS)
      PHP_MONGODB_ADD_SOURCES([src/libmongocrypt/src/os_posix/], $PHP_MONGODB_MONGOCRYPT_OS_POSIX_SOURCES, $PHP_MONGODB_LIBMONGOCRYPT_CFLAGS)
      PHP_MONGODB_ADD_SOURCES([src/libmongocrypt/src/os_win/], $PHP_MONGODB_MONGOCRYPT_OS_WIN_SOURCES, $PHP_MONGODB_LIBMONGOCRYPT_CFLAGS)
      PHP_MONGODB_ADD_SOURCES([src/libmongocrypt/kms-message/src/], $PHP_MONGODB_MONGOCRYPT_KMS_MESSAGE_SOURCES, $PHP_MONGODB_LIBMONGOCRYPT_CFLAGS)

      PHP_MONGODB_ADD_INCLUDE([src/libmongocrypt/src/])
      PHP_MONGODB_ADD_INCLUDE([src/libmongocrypt/kms-message/src/])
      PHP_MONGODB_ADD_INCLUDE([src/libmongocrypt-compat/])

      PHP_MONGODB_ADD_BUILD_DIR([src/libmongocrypt/src/])
      PHP_MONGODB_ADD_BUILD_DIR([src/libmongocrypt/src/crypto/])
      PHP_MONGODB_ADD_BUILD_DIR([src/libmongocrypt/src/os_posix/])
      PHP_MONGODB_ADD_BUILD_DIR([src/libmongocrypt/src/os_win/])
      PHP_MONGODB_ADD_BUILD_DIR([src/libmongocrypt/kms-message/src/])

      AC_CONFIG_FILES([
        ${ac_config_dir}/src/libmongocrypt/src/mongocrypt-config.h
      ])
    fi
  fi

  PHP_NEW_EXTENSION(mongodb, $PHP_MONGODB_SOURCES, $ext_shared,, $PHP_MONGODB_CFLAGS)

  PHP_SUBST(MONGODB_SHARED_LIBADD)

  PHP_ADD_EXTENSION_DEP(mongodb, date)
  PHP_ADD_EXTENSION_DEP(mongodb, json)
  PHP_ADD_EXTENSION_DEP(mongodb, spl)
  PHP_ADD_EXTENSION_DEP(mongodb, standard)

  PHP_ADD_INCLUDE(PHP_EXT_SRCDIR(mongodb)[/src/])
  PHP_ADD_INCLUDE(PHP_EXT_SRCDIR(mongodb)[/src/BSON/])
  PHP_ADD_INCLUDE(PHP_EXT_SRCDIR(mongodb)[/src/MongoDB/])
  PHP_ADD_INCLUDE(PHP_EXT_SRCDIR(mongodb)[/src/MongoDB/Exception/])
  PHP_ADD_INCLUDE(PHP_EXT_SRCDIR(mongodb)[/src/MongoDB/Monitoring/])
  PHP_ADD_INCLUDE(PHP_EXT_SRCDIR(mongodb)[/src/contrib/])

  PHP_ADD_BUILD_DIR(PHP_EXT_BUILDDIR(mongodb)[/src/])
  PHP_ADD_BUILD_DIR(PHP_EXT_BUILDDIR(mongodb)[/src/BSON/])
  PHP_ADD_BUILD_DIR(PHP_EXT_BUILDDIR(mongodb)[/src/MongoDB/])
  PHP_ADD_BUILD_DIR(PHP_EXT_BUILDDIR(mongodb)[/src/MongoDB/Exception/])
  PHP_ADD_BUILD_DIR(PHP_EXT_BUILDDIR(mongodb)[/src/MongoDB/Monitoring/])
  PHP_ADD_BUILD_DIR(PHP_EXT_BUILDDIR(mongodb)[/src/contrib/])

  dnl Necessary to ensure that static builds include "-pthread" when linking
  if test "$ext_shared" != "yes"; then
    EXTRA_LDFLAGS_PROGRAM="$EXTRA_LDFLAGS_PROGRAM $EXTRA_LDFLAGS"
  fi

  dnl This must come after PHP_NEW_EXTENSION, otherwise the srcdir won't be set
  PHP_ADD_MAKEFILE_FRAGMENT

  AC_CONFIG_COMMANDS_POST([
    if test "$enable_static" = "no"; then
      echo "
mongodb was configured with the following options:

Build configuration:
  CC                                               : $CC
  CFLAGS                                           : $CFLAGS
  CPPFLAGS                                         : $CPPFLAGS
  Extra flags                                      : $PHP_MONGODB_STD_CFLAGS
  Developer flags (slow)                           : $PHP_MONGODB_DEV_CFLAGS
  Code Coverage flags (extra slow)                 : $PHP_MONGODB_COVERAGE_CFLAGS
  libmongoc                                        : $PHP_MONGODB_BSON_VERSION_STRING
  libbson                                          : $PHP_MONGODB_MONGOC_VERSION_STRING
  libmongocrypt                                    : $PHP_MONGODB_MONGOCRYPT_VERSION_STRING
  LDFLAGS                                          : $LDFLAGS
  EXTRA_LDFLAGS                                    : $EXTRA_LDFLAGS
  MONGODB_SHARED_LIBADD                            : $MONGODB_SHARED_LIBADD

Please submit bugreports at:
  https://jira.mongodb.org/browse/PHPC

"
    fi
  ])
fi

dnl: vim: et sw=2
