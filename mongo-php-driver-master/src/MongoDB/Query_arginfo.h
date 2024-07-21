/* This is a generated file, edit the .stub.php file instead.
 * Stub hash: 76ba8473a69d995471b4f645fdcc040b13febbad */

#if PHP_VERSION_ID >= 80000
ZEND_BEGIN_ARG_INFO_EX(arginfo_class_MongoDB_Driver_Query___construct, 0, 0, 1)
	ZEND_ARG_TYPE_MASK(0, filter, MAY_BE_ARRAY|MAY_BE_OBJECT, NULL)
	ZEND_ARG_TYPE_INFO_WITH_DEFAULT_VALUE(0, queryOptions, IS_ARRAY, 1, "null")
ZEND_END_ARG_INFO()
#endif

#if !(PHP_VERSION_ID >= 80000)
ZEND_BEGIN_ARG_INFO_EX(arginfo_class_MongoDB_Driver_Query___construct, 0, 0, 1)
	ZEND_ARG_INFO(0, filter)
	ZEND_ARG_TYPE_INFO_WITH_DEFAULT_VALUE(0, queryOptions, IS_ARRAY, 1, "null")
ZEND_END_ARG_INFO()
#endif


#if PHP_VERSION_ID >= 80000
static ZEND_METHOD(MongoDB_Driver_Query, __construct);
#endif
#if !(PHP_VERSION_ID >= 80000)
static ZEND_METHOD(MongoDB_Driver_Query, __construct);
#endif


static const zend_function_entry class_MongoDB_Driver_Query_methods[] = {
#if PHP_VERSION_ID >= 80000
	ZEND_ME(MongoDB_Driver_Query, __construct, arginfo_class_MongoDB_Driver_Query___construct, ZEND_ACC_PUBLIC|ZEND_ACC_FINAL)
#endif
#if !(PHP_VERSION_ID >= 80000)
	ZEND_ME(MongoDB_Driver_Query, __construct, arginfo_class_MongoDB_Driver_Query___construct, ZEND_ACC_PUBLIC|ZEND_ACC_FINAL)
#endif
	ZEND_FE_END
};

static zend_class_entry *register_class_MongoDB_Driver_Query(void)
{
	zend_class_entry ce, *class_entry;

	INIT_NS_CLASS_ENTRY(ce, "MongoDB\\Driver", "Query", class_MongoDB_Driver_Query_methods);
	class_entry = zend_register_internal_class_ex(&ce, NULL);
	class_entry->ce_flags |= ZEND_ACC_FINAL;

	return class_entry;
}
