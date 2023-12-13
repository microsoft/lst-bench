# Workloads Definition in LST-Bench

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

A _task_ is a collection of SQL statements grouped together in a sequence of files. Each file represents a step or subtask within the overall task.

## Session

A _session_ refers to a sequence of tasks. It represents a logical unit of work or a user session.

## Phase

A _phase_ consists of multiple concurrent sessions that need to be completed before proceeding to the next phase. Phases help simulate concurrent workload scenarios.

## Workload

A _workload_ is a sequence of phases, defining the complete set of tasks, sessions, and phases to be executed during the evaluation.
