# Definition of Workloads in LST-Bench

In LST-Bench, workloads are defined using a YAML configuration file. 
The schema for this configuration file can be accessed [here](src/main/resources/schemas/workload.json). 
To facilitate the reusability of various workload components, LST-Bench enables the definition of a [library](src/main/resources/schemas/library.json). 
This library should be supplied during benchmark execution, allowing workloads to reference entities predefined within it.

LST-Bench already includes libraries encompassing tasks derived from the TPC-DS and TPC-H benchmarks, along with workload definitions that represent the original workloads specified by these standards. 
Additionally, multiple other workload patterns that are especially relevant for evaluating LSTs are also included. 
These resources can be found [here](src/main/resources/config).

While LST-Bench provides predefined libraries and workload definitions, users have the flexibility to incorporate additional task templates or even create an entirely new task library to model specific scenarios. 
This flexible model allows for the easy creation of diverse SQL workloads for evaluation purposes without necessitating modifications to the LST-Bench application itself.

Next we discuss the concepts used to define and organize SQL workloads in LST-Bench.

## Task

A _task_ in LST-Bench is a collection of SQL statements grouped together in a sequence of files. 
Each file represents a step or subtask within the overall task.

A task consists of two parts: a _template_ that defines the key elements of the task and an _instance_ that specifies arguments to instantiate the aforementioned template.

### Task Template

A task template is typically defined in the library and referenced by its identifier. For example, the following snippet shows a sample template:

```yaml
# Execution of a few TPC-DS queries (possibly in a previous point-in-time)
- id: single_user_simple
  files:
  - src/main/resources/scripts/tpcds/single_user/spark/query1.sql
  - src/main/resources/scripts/tpcds/single_user/spark/query2.sql
  - src/main/resources/scripts/tpcds/single_user/spark/query3.sql
  permutation_orders_path: src/main/resources/auxiliary/tpcds/single_user/permutation_orders/
  supports_time_travel: true
```

This template with the identifier `single_user_simple` comprises three SQL query files, each with a query. 
Note that there are a couple of additional optional properties defined, namely `permutation_orders_path` and `supports_time_travel`. 
Further information about these and other optional properties, including their descriptions, can be found [here](src/main/resources/schemas/template.json).

### Task

If we want to instantiate a task based on the `single_user_simple` template defined above as part of an input library, we can do so as follows:

```yaml
- template_id: single_user_simple
  permute_order: true
```

A task template can also be inlined within the task instantiation if we do not want to rely on a library:

```yaml
- files:
  - src/main/resources/scripts/tpcds/single_user/spark/query1.sql
  - src/main/resources/scripts/tpcds/single_user/spark/query2.sql
  - src/main/resources/scripts/tpcds/single_user/spark/query3.sql
  permutation_orders_path: src/main/resources/auxiliary/tpcds/single_user/permutation_orders/
  permute_order: true
```

Note that tasks can also have their parameters modifying their behavior for a specific instance, e.g., `permute_order`. 
These optional task parameters as well as an explanation about them can be found [here](src/main/resources/schemas/instance.json).

### Custom Tasks

<!--- TODO: Update this section --->

### Prepared Tasks

<!--- TODO: Update this section --->

## Tasks Sequences

<!--- TODO: Update this section --->


## Session

A _session_ refers to a sequence of tasks representing a logical unit of work or a user session, aligning with the concept of sessions in JDBC.

For instance, the following snippet illustrates a sample session executing the `single_user_simple` task template declared earlier:

```yaml
  - tasks:
    - template_id: single_user_simple
      permute_order: true
```

If no endpoint is specified, the session is associated with a default target endpoint—the first connection declared in the connections YAML config file.

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
