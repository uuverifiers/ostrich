SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

extract_script=$SCRIPT_DIR/extract_smt_with_count.py
Python3=~/Program_language_lib/python3/bin/python3  
$Python3 $extract_script $SCRIPT_DIR/../benchmarks/benchmark_z3str3re/automatark
$Python3 $extract_script $SCRIPT_DIR/../benchmarks/benchmark_z3str3re/RegExBenchmarks
$Python3 $extract_script $SCRIPT_DIR/../benchmarks/benchmark_z3str3re/stringfuzzregexgenerated
$Python3 $extract_script $SCRIPT_DIR/../benchmarks/benchmark_z3str3re/stringfuzzregextransformed

