/*
* |---------------------------------------------------------------|
* | SDRAM Driver                                                   |
* |                                                               |
* |---------------------------------------------------------------|
*/

class CAS_driver extends uvm_driver#(CAS_tlm);

    virtual CAS_ifc vif;

    CAS_tlm tlm;

    `uvm_component_utils(CAS_driver)

    covergroup cas_cov;
        option.per_instance = 1;
        command : coverpoint tlm.cfg_sdr_cas {
            bins low = {2};
            bins high  = {3};
        }
    endgroup


    function new (string name, uvm_component parent = null);
        super.new(name, parent);

        cas_cov = new();
        cas_cov.set_inst_name("cas_cov");
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        void'(uvm_resource_db#(virtual CAS_ifc)::read_by_name(.scope("*"), .name("cas_ifc"), .val(vif)));
        if( vif==null )
            `uvm_fatal("SDRAM_DRV","Cannot get vif");
   endfunction


    task run_phase(uvm_phase phase);
        vif.cfg_sdr_cas <= 'd0;

        forever begin
            tlm = new();
            seq_item_port.get_next_item(tlm);
            $display("CAS config: %0d",tlm.cfg_sdr_cas);
            cas_cov.sample();
            vif.cfg_sdr_cas <= tlm.cfg_sdr_cas;
            seq_item_port.item_done();
        end
    endtask

endclass : CAS_driver
