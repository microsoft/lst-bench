# Workload Definition in LST-Bench
In LST-Bench, the following concepts are used to define and organize SQL workloads:

- **Task**: A task is a collection of SQL statements grouped together in a sequence of files. Each file represents a step or subtask within the overall task.

- **Session**: A session refers to a sequence of tasks. It represents a logical unit of work or a user session.

- **Phase**: A phase consists of multiple concurrent sessions that need to be completed before proceeding to the next phase. Phases help simulate concurrent workload scenarios.

- **Workload**: A workload is a sequence of phases, defining the complete set of tasks, sessions, and phases to be executed during the evaluation.

In LST-Bench, tasks are generated using task templates predefined in the library.
LST-Bench includes a default library that encompasses tasks derived from the TPC-DS benchmark, along with workload definitions representing the original TPC-DS and multiple workload patterns. These resources can be located [here](src/main/resources/config).

Although LST-Bench provides this set of tasks and workload patterns,
users have the flexibility to incorporate additional task templates or even create a completely new task library to model specific scenarios.
This flexible model allows for the easy creation of diverse SQL workloads for evaluation purposes without the need to modify the application itself.
