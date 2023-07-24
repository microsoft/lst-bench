package com.microsoft.lst_bench.common;

import java.time.Instant;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.microsoft.lst_bench.client.ClientException;
import com.microsoft.lst_bench.client.Connection;
import com.microsoft.lst_bench.exec.FileExec;
import com.microsoft.lst_bench.exec.StatementExec;
import com.microsoft.lst_bench.exec.TaskExec;
import com.microsoft.lst_bench.telemetry.EventInfo;
import com.microsoft.lst_bench.telemetry.EventInfo.EventType;
import com.microsoft.lst_bench.telemetry.EventInfo.Status;
import com.microsoft.lst_bench.telemetry.ImmutableEventInfo;
import com.microsoft.lst_bench.telemetry.SQLTelemetryRegistry;
import com.microsoft.lst_bench.util.StringUtils;

/**
 * Default executor for tasks. Iterates over all files and all the statements
 * contained in those files and executes them sequentially.
 */
public class TaskExecutor {

    private static final Logger LOGGER = LoggerFactory.getLogger(TaskExecutor.class);

    private final Connection connection;
    private final SQLTelemetryRegistry telemetryRegistry;
    private final Map<String, Object> runtimeParameterValues;
    private final TaskExec task;
    private String experimentStartTime;

    public TaskExecutor(
        Connection connection, 
        SQLTelemetryRegistry telemetryRegistry,
        TaskExec task,
        Map<String, Object> runtimeParameterValues) {
            this.connection = connection;
            this.telemetryRegistry = telemetryRegistry;
            this.task = task;
            this.runtimeParameterValues = runtimeParameterValues;
        }

    public void execute()
        throws ClientException {
        for (FileExec file : task.getFiles()) {
        Instant fileStartTime = Instant.now();
        try {
            for (StatementExec statement : file.getStatements()) {
            Instant statementStartTime = Instant.now();
            try {
                connection.execute(StringUtils.replaceParameters(statement, this.runtimeParameterValues).getStatement());
            } catch (Exception e) {
                LOGGER.error("Exception executing statement: " + statement.getId());
                writeStatementEvent(statementStartTime, statement.getId(), Status.FAILURE);
                throw e;
            }
            writeStatementEvent(statementStartTime, statement.getId(), Status.SUCCESS);
            }
        } catch (Exception e) {
            LOGGER.error("Exception executing file: " + file.getId());
            writeFileEvent(fileStartTime, file.getId(), Status.FAILURE);
            throw e;
        }
        writeFileEvent(fileStartTime, file.getId(), Status.SUCCESS);
        }
    }

    private EventInfo writeFileEvent(Instant startTime, String id, Status status) {
        EventInfo eventInfo =
            ImmutableEventInfo.of(
                experimentStartTime, startTime, Instant.now(), id, EventType.EXEC_FILE, status);
        telemetryRegistry.writeEvent(eventInfo);
        return eventInfo;
    }

    private EventInfo writeStatementEvent(Instant startTime, String id, Status status) {
        EventInfo eventInfo =
            ImmutableEventInfo.of(
                experimentStartTime, startTime, Instant.now(), id, EventType.EXEC_STATEMENT, status);
        telemetryRegistry.writeEvent(eventInfo);
        return eventInfo;
    }
    
}