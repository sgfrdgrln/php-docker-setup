/* This is a generated file, edit the .stub.php file instead.
 * Stub hash: ff0ed638bd5aa4f82216a9af2fc22743c39d2a2b */

ZEND_BEGIN_ARG_INFO_EX(arginfo_class_MongoDB_Driver_Monitoring_ServerOpeningEvent___construct, 0, 0, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_MongoDB_Driver_Monitoring_ServerOpeningEvent_getPort, 0, 0, IS_LONG, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_TYPE_INFO_EX(arginfo_class_MongoDB_Driver_Monitoring_ServerOpeningEvent_getHost, 0, 0, IS_STRING, 0)
ZEND_END_ARG_INFO()

ZEND_BEGIN_ARG_WITH_RETURN_OBJ_INFO_EX(arginfo_class_MongoDB_Driver_Monitoring_ServerOpeningEvent_getTopologyId, 0, 0, MongoDB\\BSON\\ObjectId, 0)
ZEND_END_ARG_INFO()


static ZEND_METHOD(MongoDB_Driver_Monitoring_ServerOpeningEvent, __construct);
static ZEND_METHOD(MongoDB_Driver_Monitoring_ServerOpeningEvent, getPort);
static ZEND_METHOD(MongoDB_Driver_Monitoring_ServerOpeningEvent, getHost);
static ZEND_METHOD(MongoDB_Driver_Monitoring_ServerOpeningEvent, getTopologyId);


static const zend_function_entry class_MongoDB_Driver_Monitoring_ServerOpeningEvent_methods[] = {
	ZEND_ME(MongoDB_Driver_Monitoring_ServerOpeningEvent, __construct, arginfo_class_MongoDB_Driver_Monitoring_ServerOpeningEvent___construct, ZEND_ACC_PRIVATE|ZEND_ACC_FINAL)
	ZEND_ME(MongoDB_Driver_Monitoring_ServerOpeningEvent, getPort, arginfo_class_MongoDB_Driver_Monitoring_ServerOpeningEvent_getPort, ZEND_ACC_PUBLIC|ZEND_ACC_FINAL)
	ZEND_ME(MongoDB_Driver_Monitoring_ServerOpeningEvent, getHost, arginfo_class_MongoDB_Driver_Monitoring_ServerOpeningEvent_getHost, ZEND_ACC_PUBLIC|ZEND_ACC_FINAL)
	ZEND_ME(MongoDB_Driver_Monitoring_ServerOpeningEvent, getTopologyId, arginfo_class_MongoDB_Driver_Monitoring_ServerOpeningEvent_getTopologyId, ZEND_ACC_PUBLIC|ZEND_ACC_FINAL)
	ZEND_FE_END
};

static zend_class_entry *register_class_MongoDB_Driver_Monitoring_ServerOpeningEvent(void)
{
	zend_class_entry ce, *class_entry;

	INIT_NS_CLASS_ENTRY(ce, "MongoDB\\Driver\\Monitoring", "ServerOpeningEvent", class_MongoDB_Driver_Monitoring_ServerOpeningEvent_methods);
	class_entry = zend_register_internal_class_ex(&ce, NULL);
	class_entry->ce_flags |= ZEND_ACC_FINAL;

	return class_entry;
}
