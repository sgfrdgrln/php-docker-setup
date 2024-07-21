/*
 * Copyright 2021-present MongoDB, Inc.
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

#ifndef PHONGO_APM_H
#define PHONGO_APM_H

#include "mongoc/mongoc.h"

#include <php.h>

bool phongo_apm_set_callbacks(mongoc_client_t* client);
bool phongo_apm_add_subscriber(HashTable* subscribers, zval* subscriber);
bool phongo_apm_remove_subscriber(HashTable* subscribers, zval* subscriber);

#endif /* PHONGO_APM_H */
