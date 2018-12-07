
ROOT=$(PWD)/..
UTILS=$(ROOT)/utils
OUTPUT=$(ROOT)/output
XRUN=/p/svl/p1/proj_tools/cadence/xlm-18.03.010/tools.lnx86/bin/64bit/xrun
MAKE=make -f $(UTILS)/Makefile

SEED ?= 1
TEST ?= sdram_base_test
DW   ?= SDRAM_16BIT
COV  ?= 0

NUM ?= 1

ifeq ($(COV),1)
	COV_ARGS = ' -covoverwrite -covfile $(UTILS)/NCcovfile.cf +tcl+$(UTILS)/coverage/N$(NUM).tcl'
endif

INC_DIR = +incdir+$(ROOT)+$(ROOT)/sdram_agent+$(ROOT)/CAS_agent+$(ROOT)/src

IRUN_ARGS = -sv -uvm +xm64bit -disable_sem2009 '+tcl+$(UTILS)/dump.tcl' -access +rwc -seed $(SEED) -define SV_TEST=$(TEST) -define $(DW)

all: $(OUTPUT)
	cd $(OUTPUT) && $(XRUN) $(COV_ARGS) $(IRUN_ARGS) $(INC_DIR) $(ROOT)/tb_top.sv

$(OUTPUT):
	mkdir $(ROOT)/output

regression:
	$(MAKE) TEST=sdram_read_test COV=1 SEED=random DW=SDRAM_16BIT NUM=1
	$(MAKE) TEST=sdram_write_test COV=1 SEED=random DW=SDRAM_16BIT NUM=2
	$(MAKE) TEST=sdram_read_write_test COV=1 SEED=random DW=SDRAM_16BIT NUM=3
	$(MAKE) TEST=sdram_rw_reset_test COV=1 SEED=random DW=SDRAM_16BIT NUM=4
	$(MAKE) TEST=sdram_wr_addr_reset_test COV=1 SEED=random DW=SDRAM_16BIT NUM=5
	$(MAKE) TEST=sdram_wr_addr_test COV=1 SEED=random DW=SDRAM_16BIT NUM=6
	$(MAKE) TEST=sdram_read_test COV=1 SEED=random DW=SDRAM_32BIT NUM=8
	$(MAKE) TEST=sdram_write_test COV=1 SEED=random DW=SDRAM_32BIT NUM=9
	$(MAKE) TEST=sdram_read_write_test COV=1 SEED=random DW=SDRAM_32BIT NUM=10
	$(MAKE) TEST=sdram_rw_reset_test COV=1 SEED=random DW=SDRAM_32BIT NUM=11
	$(MAKE) TEST=sdram_wr_addr_reset_test COV=1 SEED=random DW=SDRAM_32BIT NUM=12
	$(MAKE) TEST=sdram_wr_addr_test COV=1 SEED=random DW=SDRAM_32BIT NUM=13

clean:
	cd $(OUTPUT) && rm -r ./*
