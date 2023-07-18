# VCS
VCS = vcs -full64 -LDFLAGS -Wl,-no-as-needed
DEFINE_VPD = +define+DUMP_VPD
DEFINE_DSDB = +define+DUMP_FSDB

# DVE
DVE = dve -full64

# Simulation Timescale
TIMESCALE = timescale=1ns/1ps

all: gen_flist com sim
	
gen_flist: 
	find -wholename "./rtl/*.v" > filelist.f

com:	
	$(VCS) +v2k -sverilog \
	-f filelist.f \
	-debug_access+all \
	-$(TIMESCALE) \
	-l com.log \
	$(DEFINE_DSDB)

sim:
	./simv -l sim.log

clean: clean_com clean_sim clean_verdi
	rm -rf *.log

clean_com:
	rm -rf csrc simv.daidir simv com.log

clean_sim:
	rm -rf *.key *.fsdb *.vcd *.vpd DVEfiles NOVAS_dump.log sim.log

clean_verdi:
	rm -rf ./verdiLog ./novas.*

open_dve :
	$(DVE) -vpd ./sim_output_pluson.vpd &

open_verdi:
	verdi +v2k -sverilog -f filelist.f -ssf ./sim_output_pluson.fsdb -sswr ./signal.rc &
