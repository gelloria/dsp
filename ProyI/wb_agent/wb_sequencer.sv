/*
* |---------------------------------------------------------------|
* | wb Sequencer                                               |
* |                                                               |
* |---------------------------------------------------------------|
*/

class wb_sequencer extends uvm_sequencer#(wb_tlm);

    `uvm_sequencer_utils(wb_sequencer)


    function new(input string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction

endclass : wb_sequencer
