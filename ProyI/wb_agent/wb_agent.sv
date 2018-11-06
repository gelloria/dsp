/*
* |---------------------------------------------------------------|
* | wb Agent                                                   |
* |                                                               |
* |---------------------------------------------------------------|
*/

class wb_agent extends uvm_agent;

    wb_monitor   monitor;
    wb_driver    driver;
    wb_sequencer sequencer;

    `uvm_component_utils(wb_agent)


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        monitor   = wb_monitor::type_id::create("wb_monitor", this);
        driver    = wb_driver::type_id::create("wb_driver", this);
        sequencer = wb_sequencer::type_id::create("wb_sequencer", this);
    endfunction


    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction

endclass : wb_agent
