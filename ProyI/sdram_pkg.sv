package sdram_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    //SDRAM agent
    `include "sdram_tlm.sv"
    `include "sdram_sequencer.sv"
    `include "sdram_driver.sv"
    `include "sdram_monitor.sv"
    `include "sdram_agent.sv"

    //Scoreboard
    `include "sdram_scoreboard.sv"

    //Env
    `include "sdram_env.sv"

    //Tests
    `include "sdram_test.sv"

endpackage
