
ROOT=$(PWD)/..
UTILS=$(ROOT)/utils
OUTPUT=$(ROOT)/output
XRUN=/p/svl/p1/proj_tools/cadence/xlm-18.03.010/tools.lnx86/bin/64bit/xrun

SEED ?= 1
TEST ?= sdram_base_test
DW   ?= SDRAM_16BIT
COV  ?= 0

ifeq ($(COV),1)
	COV_ARGS = ' -covoverwrite -covfile $(UTILS)/NCcovfile.cf +tcl+$(UTILS)/NCcontrol.tcl'
endif

INC_DIR = +incdir+$(ROOT)+$(ROOT)/sdram_agent+$(ROOT)/CAS_agent+$(ROOT)/src

IRUN_ARGS = -sv -uvm +xm64bit -disable_sem2009 '+tcl+$(UTILS)/dump.tcl' -access +rwc -seed $(SEED) -define SV_TEST=$(TEST) -define $(DW)

all: $(OUTPUT)
	cd $(OUTPUT) && $(XRUN) $(COV_ARGS) $(IRUN_ARGS) $(INC_DIR) $(ROOT)/tb_top.sv

$(OUTPUT):
	mkdir $(ROOT)/output

clean:
	cd $(OUTPUT) && rm -r ./*
