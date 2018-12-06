/*
* |---------------------------------------------------------------|
* | SDRAM Agent                                                   |
* |                                                               |
* |---------------------------------------------------------------|
*/

class CAS_agent extends uvm_agent;

    CAS_monitor   monitor;
    CAS_driver    driver;
    CAS_sequencer sequencer;

    `uvm_component_utils(CAS_agent)


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        monitor   = CAS_monitor::type_id::create("CAS_monitor", this);
        driver    = CAS_driver::type_id::create("CAS_driver", this);
        sequencer = CAS_sequencer::type_id::create("CAS_sequencer", this);
    endfunction


    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction

endclass : CAS_agent
