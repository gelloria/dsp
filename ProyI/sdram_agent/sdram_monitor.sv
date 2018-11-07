/*
* |---------------------------------------------------------------|
* | SDRAM Monitor                                                 |
* |                                                               |
* |---------------------------------------------------------------|
*/

class sdram_monitor extends uvm_monitor;

    virtual sdram_ifc vif;
    sdram_tlm tlm;

    uvm_analysis_port#(sdram_tlm) ch_out;

    `uvm_component_utils(sdram_monitor)


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        void'(uvm_resource_db#(virtual sdram_ifc)::read_by_name(.scope("*"), .name("sdram_ifc"), .val(vif)));
        if( vif==null )
            `uvm_fatal("SDRAM_MON","Cannot get vif");

        ch_out = new(.name("ch_out"), .parent(this));
    endfunction


    task run_phase(uvm_phase phase);
        fork
            mon();
        join
    endtask


    task mon();
        `uvm_info("SDRAM MON", "Function to monitor the DUT pins.", UVM_LOW);
    endtask

endclass : sdram_monitor
