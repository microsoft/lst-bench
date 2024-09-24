# Constants
$CAB_CONVERTER_HOME = Get-Location
$CAB_CONVERTER_CLASSPATH = "$CAB_CONVERTER_HOME\target\*;$CAB_CONVERTER_HOME\target\lib\*;$CAB_CONVERTER\target\classes\*"

# Run Java command
java -cp $CAB_CONVERTER_CLASSPATH com.microsoft.lst_bench.cab_converter.Driver $args
