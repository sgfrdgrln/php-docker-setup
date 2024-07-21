/*
 * Copyright 2017-present MongoDB, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <php.h>

#include "php_phongo.h"
#include "MaxKeyInterface_arginfo.h"

zend_class_entry* php_phongo_maxkey_interface_ce;

void php_phongo_maxkey_interface_init_ce(INIT_FUNC_ARGS)
{
	php_phongo_maxkey_interface_ce = register_class_MongoDB_BSON_MaxKeyInterface();
}
