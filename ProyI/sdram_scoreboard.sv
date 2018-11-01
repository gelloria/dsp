/*
* |---------------------------------------------------------------|
* | SDRAM Scoreboard                                              |
* |                                                               |
* |---------------------------------------------------------------|
*/

class sdram_scoreboard extends uvm_scoreboard;

    uvm_tlm_analysis_fifo#(sdram_tlm) fifo;
    sdram_tlm tlm;

    `uvm_component_utils(sdram_scoreboard)


    function new(string name, uvm_component parent);
        super.new(name, parent);
        fifo = new("fifo", this);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction


    task run_phase(uvm_phase phase);
        fork
            cnt_checker();
        join
    endtask


    task cnt_checker();
        `uvm_info("SDRAM_SCB", "Checkers should be implemented here.", UVM_LOW);
    endtask

endclass : sdram_scoreboard
