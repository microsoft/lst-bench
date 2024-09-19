/*
 * Copyright (c) Microsoft Corporation.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.microsoft.lst_bench.util;

import java.time.ZoneOffset;

/** Date time formatter. */
public class DateTimeFormatter {

  /** Formatter for experiment identifier based on its start time. */
  public static final java.time.format.DateTimeFormatter U_FORMATTER =
      java.time.format.DateTimeFormatter.ofPattern("yyyy_MM_dd_HH_mm_ss_SSS")
          .withZone(ZoneOffset.UTC);

  /** Formatter for AS OF clause in SQL queries. */
  public static final java.time.format.DateTimeFormatter AS_OF_FORMATTER =
      java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.000")
          .withZone(ZoneOffset.UTC);
}
