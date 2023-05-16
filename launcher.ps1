# Constants
$LST_BENCH_HOME = Get-Location
$LST_BENCH_CLASSPATH = "$LST_BENCH_HOME\target\*;$LST_BENCH_HOME\target\lib\*;$LST_BENCH_HOME\target\classes\*"

# Run Java command
java -cp $LST_BENCH_CLASSPATH com.microsoft.lst_bench.Driver $args
