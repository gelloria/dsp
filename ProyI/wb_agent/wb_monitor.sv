/*
* |---------------------------------------------------------------|
* | wb Monitor                                                 |
* |                                                               |
* |---------------------------------------------------------------|
*/

class wb_monitor extends uvm_monitor;

    virtual wb_ifc vif;
    wb_tlm tlm;

    uvm_analysis_port#(wb_tlm) ch_out;

    `uvm_component_utils(wb_monitor)


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        void'(uvm_resource_db#(virtual wb_ifc)::read_by_name(.scope("*"), .name("wb_ifc"), .val(vif)));
        if( vif==null )
            `uvm_fatal("wb_MON","Cannot get vif");

        ch_out = new(.name("ch_out"), .parent(this));
    endfunction


    task run_phase(uvm_phase phase);
        fork
            mon();
        join
    endtask


    task mon();
        `uvm_info("wb MON", "Function to monitore the DUT pins.", UVM_LOW);
    endtask

endclass : wb_monitor
