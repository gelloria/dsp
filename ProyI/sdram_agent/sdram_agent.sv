/*
* |---------------------------------------------------------------|
* | SDRAM Agent                                                   |
* |                                                               |
* |---------------------------------------------------------------|
*/

class sdram_agent extends uvm_agent;

    sdram_monitor   monitor;
    sdram_driver    driver;
    sdram_sequencer sequencer;

    `uvm_component_utils(sdram_agent)


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        monitor   = sdram_monitor::type_id::create("sdram_monitor", this);
        driver    = sdram_driver::type_id::create("sdram_driver", this);
        sequencer = sdram_sequencer::type_id::create("sdram_sequencer", this);
    endfunction


    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction

endclass : sdram_agent
