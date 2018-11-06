/*
* |---------------------------------------------------------------|
* | wb Driver                                                   |
* |                                                               |
* |---------------------------------------------------------------|
*/

class wb_driver extends uvm_driver#(wb_tlm);

    virtual wb_ifc vif;

    `uvm_component_utils(wb_driver)


    function new (string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        void'(uvm_resource_db#(virtual wb_ifc)::read_by_name(.scope("*"), .name("wb_ifc"), .val(vif)));
        if( vif==null )
            `uvm_fatal("wb_DRV","Cannot get vif");
    endfunction


    task run_phase(uvm_phase phase);
        fork
            drv();
        join
    endtask


    task drv();
        `uvm_info("wb DRV", "Function to drive the DUT pins.", UVM_LOW);
    endtask

endclass : wb_driver
