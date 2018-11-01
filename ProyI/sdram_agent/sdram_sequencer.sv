/*
* |---------------------------------------------------------------|
* | SDRAM Sequencer                                               |
* |                                                               |
* |---------------------------------------------------------------|
*/

class sdram_sequencer extends uvm_sequencer#(sdram_tlm);

    `uvm_sequencer_utils(sdram_sequencer)


    function new(input string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction

endclass : sdram_sequencer
