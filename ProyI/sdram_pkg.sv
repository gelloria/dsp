package sdram_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    //SDRAM agent
    `include "sdram_tlm.sv"
    `include "sdram_sequencer.sv"
    `include "sdram_driver.sv"
    `include "sdram_monitor.sv"
    `include "sdram_agent.sv"

    //CAS agent
    `include "CAS_tlm.sv"
    `include "CAS_sequencer.sv"
    `include "CAS_driver.sv"
    `include "CAS_monitor.sv"
    `include "CAS_agent.sv"

    //Scoreboard
    `include "sdram_scoreboard.sv"

    //Env
    `include "sdram_env.sv"

    //Sequences
    `include "sdram_sequence.sv"
    `include "CAS_sequence.sv"

    //Tests
    `include "sdram_base_test.sv"
    `include "sdram_read_test.sv"
    `include "sdram_write_test.sv"
    `include "sdram_read_write_test.sv"
    `include "sdram_rw_reset_test.sv"
    `include "sdram_wr_addr_test.sv"

endpackage
