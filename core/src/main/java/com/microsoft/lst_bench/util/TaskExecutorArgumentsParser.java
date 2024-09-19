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

import java.util.Map;

public class TaskExecutorArgumentsParser {

  private static final String RETRY_ERRONEOUS_QUERY_DELIMITER = ";";
  private static final String RETRY_ERRONEOUS_QUERY_STRINGS_KEY = "retry_erroneous_query_strings";
  private static final String SKIP_ERRONEOUS_QUERY_DELIMITER = ";";
  private static final String SKIP_ERRONEOUS_QUERY_STRINGS_KEY = "skip_erroneous_query_strings";
  private static final int DEFAULT_BATCH_SIZE = 1;
  private static final String DEPENDENT_TASK_BATCH_SIZE = "dependent_task_batch_size";

  public static String[] parseSkipExceptionStrings(Map<String, Object> arguments) {
    // Check whether there are any strings that errors are allowed to contain. In that case, we skip
    // the erroneous query and log a warning.
    String[] exceptionStrings;
    if (arguments == null || arguments.get(SKIP_ERRONEOUS_QUERY_STRINGS_KEY) == null) {
      exceptionStrings = new String[] {};
    } else {
      exceptionStrings =
          arguments
              .get(SKIP_ERRONEOUS_QUERY_STRINGS_KEY)
              .toString()
              .split(SKIP_ERRONEOUS_QUERY_DELIMITER);
    }
    return exceptionStrings;
  }

  public static String[] parseRetryExceptionStrings(Map<String, Object> arguments) {
    // Check whether there are any strings that tell us that we should continue to retry this query
    // until successful.
    String[] exceptionStrings;
    if (arguments == null || arguments.get(RETRY_ERRONEOUS_QUERY_STRINGS_KEY) == null) {
      exceptionStrings = new String[] {};
    } else {
      exceptionStrings =
          arguments
              .get(RETRY_ERRONEOUS_QUERY_STRINGS_KEY)
              .toString()
              .split(RETRY_ERRONEOUS_QUERY_DELIMITER);
    }
    return exceptionStrings;
  }

  public static Integer parseBatchSize(Map<String, Object> arguments) {
    // Parses the batch size, currently used for dependent task execution.
    Integer batchSize = null;
    if (arguments == null || arguments.get(DEPENDENT_TASK_BATCH_SIZE) == null) {
      batchSize = DEFAULT_BATCH_SIZE;
    } else {
      batchSize = Integer.valueOf(arguments.get(DEPENDENT_TASK_BATCH_SIZE).toString());
    }
    return batchSize;
  }
}
