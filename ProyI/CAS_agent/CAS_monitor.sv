/*
* |---------------------------------------------------------------|
* | SDRAM Monitor                                                 |
* |                                                               |
* |---------------------------------------------------------------|
*/

class CAS_monitor extends uvm_monitor;

    virtual CAS_ifc vif;
    int     cfg_sdr_cas;
    logic [2:0] read_reg;

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
        wait(vif.cfg_sdr_cas != 'd0);
        cfg_sdr_cas = vif.cfg_sdr_cas;
        fork
            cas_mon();
            read_cmd();
        join
    endtask

    task cas_mon();
        forever begin
            @(posedge vif.stb)
            if(vif.read & vif.stb) begin
                int cnt = 0;

                wait(read_reg == 'd5);
                do begin
                    cnt += 1;
                    @(posedge vif.clk);
                end while(cnt!=cfg_sdr_cas);

                if (vif.dq === 'z)
                    `uvm_error("CAS_MON", $psprintf("Cas value configured: %0d not respected. dq bus: %0x",cfg_sdr_cas,vif.dq))
            end
        end
    endtask

    task read_cmd();
        forever begin
            @(posedge vif.clk)
            read_reg = {vif.ras_n,vif.cas_n,vif.we_n};
        end
    endtask

endclass : CAS_monitor
