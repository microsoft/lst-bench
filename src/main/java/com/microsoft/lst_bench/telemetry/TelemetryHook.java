package com.microsoft.lst_bench.telemetry;

public class TelemetryHook extends Thread {

    private final JDBCTelemetryRegistry telemetryRegistry;

    public TelemetryHook(JDBCTelemetryRegistry telemetryRegistry) {
        this.telemetryRegistry = telemetryRegistry;
    }

    public void run()
    {
        telemetryRegistry.flush();
    }
    
}
