package sdram_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    //SDRAM agent
    `include "sdram_tlm.sv"
    `include "sdram_sequencer.sv"
    `include "sdram_driver.sv"
    `include "sdram_monitor.sv"
    `include "sdram_agent.sv"

    //WB agent
    //`include "wb_tlm.sv"
    //`include "wb_sequencer.sv"
    //`include "wb_driver.sv"
    //`include "wb_monitor.sv"
    //`include "wb_agent.sv"

    //Scoreboard
    `include "sdram_scoreboard.sv"

    //Env
    `include "sdram_env.sv"

    //Sequences
    `include "sdram_sequence.sv"

    //Tests
    `include "sdram_test.sv"
endpackage
