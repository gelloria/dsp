/*
* |---------------------------------------------------------------|
* | SDRAM Sequencer                                               |
* |                                                               |
* |---------------------------------------------------------------|
*/

class CAS_sequencer extends uvm_sequencer#(CAS_tlm);

    `uvm_sequencer_utils(CAS_sequencer)


    function new(input string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction

endclass : CAS_sequencer
