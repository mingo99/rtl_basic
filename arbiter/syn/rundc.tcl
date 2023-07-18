set TOP_LEVEL rr_arb

source ./scripts/setup.tcl

echo "*** Reading Design ***"
source -echo -v ./scripts/read_rtl.tcl > ./log/read_rtl.log

echo "*** Constrainting Design ***"
source -echo -v ./scripts/constrains.tcl > ./log/constrains.log

check_design
check_timing

compile_ultra

source ./scripts/report.tcl
