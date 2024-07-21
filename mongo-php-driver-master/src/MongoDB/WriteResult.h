/*
 * Copyright 2022-present MongoDB, Inc.
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

#ifndef PHONGO_WRITERESULT_H
#define PHONGO_WRITERESULT_H

#include "bson/bson.h"

#include <php.h>

php_phongo_writeresult_t* phongo_writeresult_init(zval* return_value, bson_t* reply, zval* manager, uint32_t server_id);

#endif /* PHONGO_WRITERESULT_H */
