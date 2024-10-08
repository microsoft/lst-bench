# Definition of Workloads in LST-Bench

In LST-Bench, workloads are defined using a YAML configuration file. 
The schema for this configuration file can be accessed [here](/core/src/main/resources/schemas/workload.json). 
To facilitate the reusability of various workload components, LST-Bench enables the definition of a [library](/core/src/main/resources/schemas/library.json). 
This library should be supplied during benchmark execution, allowing workloads to reference entities predefined within it.

LST-Bench already includes libraries encompassing tasks derived from the TPC-DS and TPC-H benchmarks, along with workload definitions that represent the original workloads specified by these standards. 
Additionally, multiple other workload patterns that are especially relevant for evaluating LSTs are also included. 
These resources can be found [here](/core/src/main/resources/config).

While LST-Bench provides predefined libraries and workload definitions, users have the flexibility to incorporate additional task templates or even create an entirely new task library to model specific scenarios. 
This flexible model allows for the easy creation of diverse SQL workloads for evaluation purposes without necessitating modifications to the LST-Bench application itself.

Next we discuss the concepts used to define and organize SQL workloads in LST-Bench.

## Task

A _task_ in LST-Bench is a collection of SQL statements grouped together in a sequence of files. 
Each file represents a step or subtask within the overall task.

A task consists of two parts: a _template_ that defines the key elements of the task and an _instance_ that specifies arguments to instantiate the aforementioned template.

### Task Template

A task template is typically defined in the library and referenced by its identifier. For example, the following snippet shows a sample template defined as part of the `task_templates` block in a library:

```yaml
task_templates:
# Execution of a few TPC-DS queries (possibly in a previous point-in-time)
- id: single_user_simple
  files:
  - core/src/main/resources/scripts/tpcds/single_user/spark/query1.sql
  - core/src/main/resources/scripts/tpcds/single_user/spark/query2.sql
  - core/src/main/resources/scripts/tpcds/single_user/spark/query3.sql
  permutation_orders_path: core/src/main/resources/auxiliary/tpcds/single_user/permutation_orders/
  supports_time_travel: true
```

This template with the identifier `single_user_simple` comprises three SQL query files, each with a query. 
Note that there are a couple of additional optional properties defined, namely `permutation_orders_path` and `supports_time_travel`. 
Further information about these and other optional properties, including their descriptions, can be found [here](/core/src/main/resources/schemas/template.json).

### Task Instance

If we want to instantiate a task based on the `single_user_simple` template defined above as part of an input library, we can do so as follows:

```yaml
- template_id: single_user_simple
  permute_order: true
```

A task template can also be inlined within the task instantiation if we do not want to rely on a library:

```yaml
- files:
  - core/src/main/resources/scripts/tpcds/single_user/spark/query1.sql
  - core/src/main/resources/scripts/tpcds/single_user/spark/query2.sql
  - core/src/main/resources/scripts/tpcds/single_user/spark/query3.sql
  permutation_orders_path: core/src/main/resources/auxiliary/tpcds/single_user/permutation_orders/
  permute_order: true
```

Note that tasks can also have their parameters modifying their behavior for a specific instance, e.g., `permute_order`. 
These optional task parameters as well as an explanation about them can be found [here](/core/src/main/resources/schemas/instance.json).

### Custom Tasks

Custom tasks allow users to specify their own task execution classes to change execution order, add dependencies between tasks, or pass custom parameters that influence task execution dynamically, amongst others.
The exact implementation is left to the user, however, they need to inherit from and abide to the API's of the `TaskExecutor` class that can be found [here](/core/src/main/java/com/microsoft/lst_bench/task/TaskExecutor.java). 
The execution class as well as the task's arguments are defined in the workload configuration via the `custom_task_executor` and `task_executor_arguments` keywords respectively.
An example is shown here, based on the implementation of the custom [DependentTaskExecutor](/core/src/main/java/com/microsoft/lst_bench/task/custom/DependentTaskExecutor.java) class:

```yaml
- template_id: data_maintenance_dependent
  custom_task_executor: com.microsoft.lst_bench.task.custom.DependentTaskExecutor
  task_executor_arguments:
    dependent_task_batch_size: 100
```

The task executor arguments are passed as a <String, Object> map, new parameters should be registered via the [TaskExecutorArgumentsParser](/core/src/main/java/com/microsoft/lst_bench/util/TaskExecutorArgumentsParser.java) to ensure that only valid parameters are passed into the execution.
An example for how task-specific arguments can be incorporated into the execution class, refer to the [DependentTaskExecutorArguments](/core/src/main/java/com/microsoft/lst_bench/task/custom/DependentTaskExecutor.java).

### Prepared Tasks

A _prepared task_ is a [task instantiation](#task-instance) defined as part of the input library. For example, we can define a prepared task in the `prepared_tasks` block in the library as follows:

```yaml
prepared_tasks:
- id: prepared_single_user_simple
  template_id: single_user_simple
  permute_order: true
```

Then, from the workload file, we can reference the _prepared task_ declared in the library, facilitating reuse and readability of the workload file:

```yaml
- prepared_task_id: prepared_single_user_simple
```

## Tasks Sequences

A _tasks sequence_ refers to a sequence of tasks that can be combined as part of a [session](#session) definition. We can define a sequence in the `tasks_sequence` block in the library as follows:

```yaml
prepared_tasks_sequences:
- id: seq_two_single_user_simple
  tasks:
  - prepared_task_id: prepared_single_user_simple
  - prepared_task_id: prepared_single_user_simple
```

Once that is done, we can reference the sequence in the workload file:

```yaml
- prepared_tasks_sequence_id: seq_two_single_user_simple
```

## Session

A _session_ refers to a collection of tasks representing a logical unit of work or a user session, aligning with the concept of sessions in JDBC.

For instance, the following snippet illustrates a sample session executing the `single_user_simple` task template declared earlier:

```yaml
  - tasks:
    - template_id: single_user_simple
      permute_order: true
```

If no endpoint is specified, the session is associated with a default target endpoint—the first connection declared in the connections YAML config file.

Tasks within a session can be executed either concurrently or sequentially, based on workload requirements.
For concurrent execution, each task must specify a start time relative to the beginning of the session, and the maximum number of tasks that can run in parallel should be defined at the session level.
Note that tasks with defined start time cannot be mixed with those without in the same session.
The following snippet demonstrates a session executing tasks concurrently:

```yaml
  - tasks:
    - template_id: single_user_simple
      permute_order: true
      start: 0
    - template_id: single_user_simple
      permute_order: true
      start: 10000
    - template_id: single_user_simple
      permute_order: true
      start: 20000     
    max_concurrency: 2
```

Additionally, a session can also be defined using tasks sequences. For instance, the following snippet demonstrates a sample session that combines two sequences: one previously defined in the library and another inlined sequence using a `tasks` block. This session will execute a total of four `single_user_simple` tasks.

```yaml
  - tasks_sequences:
    - prepared_tasks_sequence_id: seq_two_single_user_simple
    - tasks:
      - template_id: single_user_simple
        permute_order: true
      - template_id: single_user_simple
        permute_order: true
```

## Phase

A _phase_ consists of multiple concurrent sessions that need to be completed before proceeding to the next phase. Phases help simulate concurrent workload scenarios.

Consider the following snippet demonstrating a phase executing four sessions concurrently across two different target endpoints:

```yaml
- id: throughput_simple
  sessions:
  - tasks:
    - template_id: single_user_simple
      permute_order: true
    target_endpoint: 0
  - tasks:
    - template_id: single_user_simple
      permute_order: true
    target_endpoint: 0
  - tasks:
    - template_id: single_user_simple
      permute_order: true
    target_endpoint: 1
  - tasks:
    - template_id: single_user_simple
      permute_order: true
    target_endpoint: 1
```

Note that users are required to provide a unique identifier for each phase in their workload.

## Workload

A _workload_ is a sequence of phases, defining the complete set of tasks, sessions, and phases to be executed during the evaluation.

To illustrate, here is the definition of a workload that executes warm-up phases in two different engines and subsequently executes a throughput phase:

```yaml
id: my_first_workload
phases:
- id: warm_up_0
  sessions:
  - tasks:
    - template_id: single_user_simple
    target_endpoint: 0
- id: warm_up_1
  sessions:
  - tasks:
    - template_id: single_user_simple
    target_endpoint: 1
- id: throughput_simple
  sessions:
  - tasks:
    - template_id: single_user_simple
      permute_order: true
    target_endpoint: 0
  - tasks:
    - template_id: single_user_simple
      permute_order: true
    target_endpoint: 0
  - tasks:
    - template_id: single_user_simple
      permute_order: true
    target_endpoint: 1
  - tasks:
    - template_id: single_user_simple
      permute_order: true
    target_endpoint: 1
```
