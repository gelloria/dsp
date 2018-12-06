/*
* |---------------------------------------------------------------|
* | SDRAM Monitor                                                 |
* |                                                               |
* |---------------------------------------------------------------|
*/

class CAS_monitor extends uvm_monitor;

    virtual CAS_ifc vif;

    uvm_analysis_port#(CAS_tlm) ch_out;

    `uvm_component_utils(CAS_monitor)


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        void'(uvm_resource_db#(virtual CAS_ifc)::read_by_name(.scope("*"), .name("cas_ifc"), .val(vif)));
        if( vif==null )
            `uvm_fatal("CAS_MON","Cannot get vif");

        ch_out = new(.name("ch_out"), .parent(this));
    endfunction


    task run_phase(uvm_phase phase);
    endtask

endclass : CAS_monitor
