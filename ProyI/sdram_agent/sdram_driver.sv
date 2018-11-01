/*
* |---------------------------------------------------------------|
* | SDRAM Driver                                                   |
* |                                                               |
* |---------------------------------------------------------------|
*/

class sdram_driver extends uvm_driver#(sdram_tlm);

    virtual sdram_ifc vif;

    `uvm_component_utils(sdram_driver)


    function new (string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        void'(uvm_resource_db#(virtual sdram_ifc)::read_by_name(.scope("*"), .name("sdram_ifc"), .val(vif)));
        if( vif==null )
            `uvm_fatal("SDRAM_DRV","Cannot get vif");
    endfunction


    task run_phase(uvm_phase phase);
        fork
            drv();
        join
    endtask


    task drv();
        `uvm_info("SDRAM DRV", "Function to drive the DUT pins.", UVM_LOW);
    endtask

endclass : sdram_driver
